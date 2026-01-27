#!/bin/bash

# new-submodule-branch.sh
# Creates a new branch in a submodule and updates the harness configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HARNESS_ROOT="$(dirname "$SCRIPT_DIR")"

# Default values
SUBMODULE_NAME=""
BRANCH_NAME=""
BASE_BRANCH="main"

# Function to show usage
usage() {
    echo "Usage: $0 --submodule <name> --branch <name> [--base <branch>]"
    echo ""
    echo "Creates a new branch in the specified submodule"
    echo ""
    echo "Options:"
    echo "  --submodule <name>    Name of the submodule"
    echo "  --branch <name>       Name of the new branch to create"
    echo "  --base <branch>       Base branch to create from (default: main)"
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
        --base)
            BASE_BRANCH="$2"
            shift 2
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

# Create new branch in submodule
echo "Creating branch '$BRANCH_NAME' in submodule '$SUBMODULE_NAME' from '$BASE_BRANCH'..."
cd "$SUBMODULE_PATH"

# Fetch latest changes
git fetch origin

# Create and checkout new branch
git checkout -b "$BRANCH_NAME" "origin/$BASE_BRANCH"

echo "Branch '$BRANCH_NAME' created successfully in submodule '$SUBMODULE_NAME'"
echo "Current directory: $(pwd)"
echo "Current branch: $(git branch --show-current)"