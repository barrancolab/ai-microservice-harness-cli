#!/bin/bash
# new-harness.sh
# Creates a new git worktree with selective submodule initialization for feature development.
#
# Usage: ./scripts/new-harness.sh <TICKET> [--change-type <type>] [--suffix <suffix>] [--purpose <purpose>] <service1> [service2] ...
# Example: ./scripts/new-harness.sh Jira-123 rgl-node-sync-api rgl-node-etl-document-delta-app
# Example: ./scripts/new-harness.sh Jira-456 --change-type fix rgl-node-sync-api
# Example: ./scripts/new-harness.sh Jira-789 --change-type feat --suffix api-refactor --purpose "Refactor API endpoints" rgl-node-sync-api

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
CHANGE_TYPE="feat"
SUFFIX=""
TICKET=""
PURPOSE=""

# Function to display usage
show_usage() {
    echo "Usage: $0 [TICKET] [--change-type <type>] [--suffix <suffix>] [--purpose <purpose>] <service1> [service2] ..."
    echo ""
    echo "Arguments:"
    echo "  TICKET                  (optional) Jira ticket ID (e.g., Jira-123)"
    echo "  service                 One or more service names to initialize"
    echo ""
    echo "Options:"
    echo "  --change-type <type>    Branch type prefix (default: feat)"
    echo "                          Common values: feat, fix, chore, refactor, docs"
    echo "  --suffix <suffix>       Required if no ticket provided"
    echo "                          Creates branch: <TICKET>-<change_type>/<suffix> or <suffix>"
    echo "  --purpose <purpose>     Purpose description for the feature/change"
    echo ""
    echo "Available services:"
    cd "$GIT_ROOT" && git submodule status | awk '{print "  " $2}'
}

# Check if first argument is a ticket or option
if [[ "$1" != --* && $# -ge 2 ]]; then
    TICKET=$1
    shift
fi

# Validate minimum arguments (need at least one service and either ticket or suffix)
if [ $# -lt 1 ]; then
    echo -e "${RED}Error: Missing required arguments${NC}"
    echo ""
    show_usage
    exit 1
fi

# Parse optional flags
SERVICES=()
while [ $# -gt 0 ]; do
    case "$1" in
        --change-type)
            if [ -z "$2" ] || [[ "$2" == --* ]]; then
                echo -e "${RED}Error: --change-type requires a value${NC}"
                exit 1
            fi
            CHANGE_TYPE="$2"
            shift 2
            ;;
         --suffix)
            if [ -z "$2" ] || [[ "$2" == --* ]]; then
                echo -e "${RED}Error: --suffix requires a value${NC}"
                exit 1
            fi
            SUFFIX="$2"
            shift 2
            ;;
         --purpose)
            if [ -z "$2" ] || [[ "$2" == --* ]]; then
                echo -e "${RED}Error: --purpose requires a value${NC}"
                exit 1
            fi
            PURPOSE="$2"
            shift 2
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        *)
            SERVICES+=("$1")
            shift
            ;;
    esac
done

# Validate we have at least one service
if [ ${#SERVICES[@]} -lt 1 ]; then
    echo -e "${RED}Error: At least one service must be specified${NC}"
    echo ""
    show_usage
    exit 1
fi

# Validate that we have either a ticket or a suffix
if [ -z "$TICKET" ] && [ -z "$SUFFIX" ]; then
    echo -e "${RED}Error: Either TICKET or --suffix must be specified${NC}"
    echo ""
    show_usage
    exit 1
fi

# Construct harness identifier and branch name
if [ -n "$TICKET" ]; then
    WORKSPACE_IDENTIFIER="${TICKET}"
    if [ -n "$SUFFIX" ]; then
        BRANCH_NAME="${TICKET}-${CHANGE_TYPE}/${SUFFIX}"
    else
        BRANCH_NAME="${TICKET}-${CHANGE_TYPE}"
    fi
else
    # No ticket, use suffix as both harness identifier and branch name
    WORKSPACE_IDENTIFIER="${SUFFIX}"
    BRANCH_NAME="${SUFFIX}"
fi

# Function to get git repository root
get_git_root() {
    local dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    echo "Error: Not in a git repository" >&2
    return 1
}

GIT_ROOT="$(get_git_root)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HARNESS_NAME="$(basename "$GIT_ROOT")"
WORKTREE_PATH="${GIT_ROOT}-${WORKSPACE_IDENTIFIER}"

# Check if worktree already exists
if [ -d "$WORKTREE_PATH" ]; then
    echo -e "${RED}Error: Worktree already exists at ${WORKTREE_PATH}${NC}"
    echo "To remove it, run: ./scripts/cleanup-workspace.sh ${WORKSPACE_IDENTIFIER}"
    exit 1
fi

# Validate that all specified services are valid submodules
echo -e "${YELLOW}Validating services...${NC}"
AVAILABLE_SUBMODULES=$(cd "$GIT_ROOT" && git submodule status | awk '{print $2}')
for service in "${SERVICES[@]}"; do
    if ! echo "$AVAILABLE_SUBMODULES" | grep -q "^${service}$"; then
        echo -e "${RED}Error: '${service}' is not a valid submodule${NC}"
        echo ""
        echo "Available services:"
        echo "$AVAILABLE_SUBMODULES" | sed 's/^/  /'
        exit 1
    fi
done

# Create the worktree
echo -e "${YELLOW}Creating worktree at ${WORKTREE_PATH}...${NC}"
WORKTREE_BRANCH="${WORKSPACE_IDENTIFIER}-workspace"
cd "$GIT_ROOT"
git worktree add "$WORKTREE_PATH" -b "$WORKTREE_BRANCH" 2>/dev/null || {
    # Branch might already exist, try without -b
    git worktree add "$WORKTREE_PATH" "$WORKTREE_BRANCH" 2>/dev/null || {
        # If that fails too, create worktree in detached state and create branch
        git worktree add --detach "$WORKTREE_PATH"
        cd "$WORKTREE_PATH"
        git checkout -b "$WORKTREE_BRANCH"
    }
}

cd "$WORKTREE_PATH"

# Initialize only the specified submodules
echo -e "${YELLOW}Initializing submodules: ${SERVICES[*]}...${NC}"
git submodule update --init "${SERVICES[@]}"

# Create feature branches in each submodule
echo -e "${YELLOW}Creating feature branches in submodules...${NC}"
for service in "${SERVICES[@]}"; do
    echo "  Branching ${service}..."
    cd "$WORKTREE_PATH/$service"
    
    # Get the configured branch from .gitmodules, fallback to default branch
    CONFIGURED_BRANCH=$(git config -f "$WORKTREE_PATH/.gitmodules" submodule."$service".branch 2>/dev/null)
    if [ -n "$CONFIGURED_BRANCH" ]; then
        BASE_BRANCH="$CONFIGURED_BRANCH"
        echo "    Using configured branch: ${BASE_BRANCH}"
    else
        BASE_BRANCH=$(git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
        echo "    Using default branch: ${BASE_BRANCH}"
    fi
    
    # Fetch latest and create feature branch from configured/default branch
    git fetch origin "$BASE_BRANCH"
    git checkout --no-track -b "${BRANCH_NAME}" "origin/${BASE_BRANCH}"
    git push -u origin "${BRANCH_NAME}"
    echo "    Created and pushed branch: ${BRANCH_NAME}"
done

# Generate HARNESS_SCOPE.md
cd "$WORKTREE_PATH"
cat > HARNESS_SCOPE.md << EOF
# Harness: ${WORKSPACE_IDENTIFIER}

Created: $(date '+%Y-%m-%d %H:%M:%S')

## Active Services

$(for service in "${SERVICES[@]}"; do echo "- ${service}"; done)

## Branch Information

| Service | Branch | Base |
|---------|--------|------|
$(for service in "${SERVICES[@]}"; do
    cd "$WORKTREE_PATH/$service"
    # Get the configured branch from .gitmodules, fallback to default branch
    CONFIGURED_BRANCH=$(git config -f "$WORKTREE_PATH/.gitmodules" submodule."$service".branch 2>/dev/null)
    if [ -n "$CONFIGURED_BRANCH" ]; then
        BASE_BRANCH="$CONFIGURED_BRANCH"
    else
        BASE_BRANCH=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}')
    fi
    echo "| ${service} | ${BRANCH_NAME} | ${BASE_BRANCH} |"
done)

## Purpose

EOF

# Add purpose if provided, otherwise use placeholder
if [ -n "$PURPOSE" ]; then
    echo "${PURPOSE}" >> HARNESS_SCOPE.md
else
    echo "<!-- Describe the feature/change being implemented in this harness -->" >> HARNESS_SCOPE.md
fi

cat >> HARNESS_SCOPE.md << EOF

## Related Links

EOF

cat >> HARNESS_SCOPE.md << EOF

## Notes

- Only the services listed above are initialized in this harness
- Other service directories exist but are empty
- Do not attempt to modify uninitialized services
EOF

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Harness created successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Location: ${WORKTREE_PATH}"
echo ""
echo "Initialized services:"
for service in "${SERVICES[@]}"; do
    echo "  - ${service} (branch: ${BRANCH_NAME})"
done
echo ""
echo "Next steps:"
echo "  1. cd ${WORKTREE_PATH}"
echo "  2. Open in IDE (if available)"
echo "  3. Update HARNESS_SCOPE.md with feature details"
echo ""
