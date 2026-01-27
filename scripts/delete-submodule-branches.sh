#!/bin/bash

# delete-submodule-branches.sh
# Deletes branches in submodules and cleans up harness configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HARNESS_ROOT="$(dirname "$SCRIPT_DIR")"

# Default values
SUBMODULE_NAME=""
BRANCH_NAME=""
FORCE_DELETE=false

# Function to show usage
usage() {
    echo "Usage: $0 --submodule <name> --branch <name> [--force]"
    echo ""
    echo "Deletes a branch in the specified submodule"
    echo ""
    echo "Options:"
    echo "  --submodule <name>    Name of the submodule"
    echo "  --branch <name>       Name of the branch to delete"
    echo "  --force               Force delete branch even if not merged"
    echo "  --help                Show this help message"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --submodule)
            SUBMODULE_NAME="$2"
            shift 2
            ;;
        --branch)
            BRANCH_NAME="$2"
            shift 2
            ;;
        --force)
            FORCE_DELETE=true
            shift
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate arguments
if [[ -z "$SUBMODULE_NAME" ]]; then
    echo "Error: --submodule is required"
    usage
fi

if [[ -z "$BRANCH_NAME" ]]; then
    echo "Error: --branch is required"
    usage
fi

# Check if submodule exists
SUBMODULE_PATH="$HARNESS_ROOT/submodules/$SUBMODULE_NAME"
if [[ ! -d "$SUBMODULE_PATH" ]]; then
    echo "Error: Submodule '$SUBMODULE_NAME' does not exist at $SUBMODULE_PATH"
    exit 1
fi

# Delete branch in submodule
echo "Deleting branch '$BRANCH_NAME' in submodule '$SUBMODULE_NAME'..."
cd "$SUBMODULE_PATH"

# Switch to main branch if currently on the branch to delete
if [[ "$(git branch --show-current)" == "$BRANCH_NAME" ]]; then
    echo "Switching to main branch before deletion..."
    git checkout main
fi

# Delete branch
if [[ "$FORCE_DELETE" == true ]]; then
    git branch -D "$BRANCH_NAME"
    echo "Force deleted branch '$BRANCH_NAME'"
else
    git branch -d "$BRANCH_NAME"
    echo "Deleted branch '$BRANCH_NAME'"
fi

echo "Branch '$BRANCH_NAME' deleted successfully from submodule '$SUBMODULE_NAME'"