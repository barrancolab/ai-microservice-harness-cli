#!/bin/bash

# new-harness-worktree.sh
# Creates a new git worktree for the harness with specific configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HARNESS_ROOT="$(dirname "$SCRIPT_DIR")"

# Default values
WORKTREE_NAME=""
WORKTREE_PATH=""
BRANCH="main"
INCLUDE_SUBMODULES=false

# Function to show usage
usage() {
    echo "Usage: $0 --name <name> [--path <path>] [--branch <branch>] [--submodules]"
    echo ""
    echo "Creates a new git worktree for the harness"
    echo ""
    echo "Options:"
    echo "  --name <name>         Name of the worktree (used for path if --path not specified)"
    echo "  --path <path>         Full path for the worktree"
    echo "  --branch <branch>     Branch to create worktree from (default: main)"
    echo "  --submodules          Include and initialize submodules"
    echo "  --help                Show this help message"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            WORKTREE_NAME="$2"
            shift 2
            ;;
        --path)
            WORKTREE_PATH="$2"
            shift 2
            ;;
        --branch)
            BRANCH="$2"
            shift 2
            ;;
        --submodules)
            INCLUDE_SUBMODULES=true
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
if [[ -z "$WORKTREE_NAME" ]]; then
    echo "Error: --name is required"
    usage
fi

# Set default path if not specified
if [[ -z "$WORKTREE_PATH" ]]; then
    WORKTREE_PATH="$HARNESS_ROOT/../$WORKTREE_NAME"
fi

# Create worktree
echo "Creating worktree '$WORKTREE_NAME' at '$WORKTREE_PATH' from branch '$BRANCH'..."
cd "$HARNESS_ROOT"

git worktree add "$WORKTREE_PATH" "$BRANCH"

echo "Worktree created successfully"

# Initialize submodules if requested
if [[ "$INCLUDE_SUBMODULES" == true ]]; then
    echo "Initializing submodules..."
    cd "$WORKTREE_PATH"
    git submodule update --init --recursive
    echo "Submodules initialized"
fi

echo "Worktree '$WORKTREE_NAME' is ready at: $WORKTREE_PATH"