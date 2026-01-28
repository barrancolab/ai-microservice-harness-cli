#!/bin/bash
# cleanup-harness.sh
# Removes a feature harness created by the create-harness skill

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
show_usage() {
    echo "Usage: $0 <IDENTIFIER>"
    echo ""
    echo "Arguments:"
    echo "  IDENTIFIER             Harness identifier (ticket ID or suffix)"
    echo ""
    echo "Example:"
    echo "  $0 Jira-123            # Remove harness for ticket Jira-123"
    echo "  $0 experiment          # Remove harness with suffix 'experiment'"
}

# Validate arguments
if [ $# -lt 1 ]; then
    echo -e "${RED}Error: Missing harness identifier${NC}"
    echo ""
    show_usage
    exit 1
fi

IDENTIFIER=$1

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
HARNESS_NAME="$(basename "$GIT_ROOT")"
WORKTREE_PATH="${GIT_ROOT}-${IDENTIFIER}"

# Check if worktree exists
if [ ! -d "$WORKTREE_PATH" ]; then
    echo -e "${RED}Error: Worktree not found at ${WORKTREE_PATH}${NC}"
    echo "Available harnesses can be listed with: git worktree list"
    exit 1
fi

# Confirm removal
echo -e "${YELLOW}This will remove the harness at:${NC}"
echo "  ${WORKTREE_PATH}"
echo ""
read -p "Are you sure you want to continue? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Remove worktree
echo -e "${YELLOW}Removing worktree...${NC}"
cd "$GIT_ROOT"
git worktree remove "$WORKTREE_PATH"

# Remove worktree branch if it exists
WORKTREE_BRANCH="${IDENTIFIER}-workspace"
if git show-ref --verify --quiet "refs/heads/${WORKTREE_BRANCH}"; then
    echo -e "${YELLOW}Removing worktree branch...${NC}"
    git branch -D "${WORKTREE_BRANCH}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Harness removed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Removed harness: ${WORKTREE_PATH}"