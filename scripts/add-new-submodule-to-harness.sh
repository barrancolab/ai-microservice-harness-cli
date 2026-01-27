#!/bin/bash

# add-new-submodule-to-harness.sh
# Adds a new submodule to the harness configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HARNESS_ROOT="$(dirname "$SCRIPT_DIR")"

# Default values
SUBMODULE_NAME=""
REPO_URL=""
BRANCH="main"
INIT_SUBMODULE=false

# Function to show usage
usage() {
    echo "Usage: $0 --name <name> --url <url> [--branch <branch>] [--init]"
    echo ""
    echo "Adds a new submodule to the harness"
    echo ""
    echo "Options:"
    echo "  --name <name>         Name/identifier for the submodule"
    echo "  --url <url>           Git repository URL"
    echo "  --branch <branch>     Branch to clone (default: main)"
    echo "  --init                Initialize the submodule after adding"
    echo "  --help                Show this help message"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            SUBMODULE_NAME="$2"
            shift 2
            ;;
        --url)
            REPO_URL="$2"
            shift 2
            ;;
        --branch)
            BRANCH="$2"
            shift 2
            ;;
        --init)
            INIT_SUBMODULE=true
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
    echo "Error: --name is required"
    usage
fi

if [[ -z "$REPO_URL" ]]; then
    echo "Error: --url is required"
    usage
fi

# Add submodule
echo "Adding submodule '$SUBMODULE_NAME' from '$REPO_URL' (branch: $BRANCH)..."
cd "$HARNESS_ROOT"

git submodule add -b "$BRANCH" "$REPO_URL" "submodules/$SUBMODULE_NAME"

echo "Submodule added successfully"

# Initialize submodule if requested
if [[ "$INIT_SUBMODULE" == true ]]; then
    echo "Initializing submodule..."
    git submodule update --init "submodules/$SUBMODULE_NAME"
    echo "Submodule initialized"
fi

# Update .gitmodules if needed
echo "Updating .gitmodules configuration..."
git add .gitmodules
git commit -m "Add submodule: $SUBMODULE_NAME from $REPO_URL"

echo "Submodule '$SUBMODULE_NAME' has been successfully added to the harness"