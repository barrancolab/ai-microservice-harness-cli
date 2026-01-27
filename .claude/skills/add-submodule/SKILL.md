---
name: add-submodule
description: Adds a git submodule to the harness. Use when adding a new repository as a submodule, either from a local file path or remote URL. Supports optional branch/ref specification.
---

# Add Submodule

Adds a git repository as a submodule to the harness.

## Parameters

- **repo_path** (required): Either a local file path to another git repository or a remote URL
- **ref** (optional): Git branch, tag, or commit hash to track. Uses default branch if not specified.

## Process

1. **Validate repository**: Check if the provided path/URL is accessible and is a valid git repository
2. **Determine submodule name**: Extract repository name from the path/URL
3. **Add to .gitmodules**: Update the .gitmodules file with the new submodule configuration
4. **Initialize submodule**: Run git submodule add with the specified ref
5. **Optionally Update and initialize**: Upon completion, ask the user if you should run git submodule update --init to initialize the new submodule

## Usage Examples

**Add from remote URL:**
```bash
# Add main branch
git submodule add https://github.com/user/repo.git submodules/repo

# Add specific branch
git submodule add -b develop https://github.com/user/repo.git submodules/repo

# Add specific tag
git submodule add -b v1.2.3 https://github.com/user/repo.git submodules/repo
```

**Add from local path:**
```bash
# Add local repository
git submodule add /path/to/local/repo submodules/local-repo
```

## .gitmodules Format

The skill updates .gitmodules with entries like:
```ini
[submodule "submodules/repo"]
	path = submodules/repo
	url = https://github.com/user/repo.git
	branch = main
```

## Error Handling

- Validates repository accessibility before adding
- Checks for duplicate submodule paths
- Verifies .gitmodules file format
- Handles both SSH and HTTPS URLs
- Supports relative and absolute local paths
