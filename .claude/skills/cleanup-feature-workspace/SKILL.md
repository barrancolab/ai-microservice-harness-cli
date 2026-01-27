---
name: cleanup-feature-workspace
description: Removes a feature workspace created by the create-feature-workspace skill. Use when you need to clean up workspaces that are no longer needed.
---

# Cleanup Feature Workspace

Safely removes a feature workspace created by the `create-feature-workspace` skill, including both the worktree directory and associated git branch.

## Parameters

- **identifier** (required): Workspace identifier (ticket ID or suffix used when creating the workspace)

## Process

1. **Validate identifier**: Check that workspace exists
2. **Confirm deletion**: Show what will be removed and require user confirmation
3. **Remove worktree**: Use `git worktree remove` to safely remove the worktree
4. **Remove branch**: Delete the associated git branch if it exists
5. **Report results**: Confirm successful removal

## Usage Examples

**Remove workspace for a ticket:**
```
Cleanup workspace Jira-123
```

**Remove workspace created with suffix:**
```
Cleanup workspace experiment
```

**Remove workspace with complex identifier:**
```
Cleanup workspace api-migration-phase-1
```

## Script Execution

The skill executes `.claude/skills/cleanup-feature-workspace/scripts/cleanup-workspace.sh` with the workspace identifier.

## Safety Features

- **Confirmation prompt**: Requires explicit user confirmation before deletion
- **Validation**: Checks workspace exists before attempting removal
- **Git safety**: Uses proper git worktree removal to avoid repository corruption
- **Clear feedback**: Shows exactly what will be removed before confirming

## What Gets Removed

1. **Worktree directory**: The workspace directory (e.g., `../{harness-name}-workspace-{identifier}/`)
2. **Git branch**: The worktree branch (e.g., `{identifier}-workspace`)
3. **All workspace contents**: Including generated documentation and any local changes

## Important Notes

- **Run from main workspace**: Execute this skill from your main harness workspace, not from the workspace being removed
- **Backup important changes**: Ensure any work you want to keep is pushed or backed up before cleanup
- **Irreversible**: Cleanup permanently removes the workspace and branch
- **Only removes workspaces**: Will not affect other directories or branches

## Error Handling

- Validates identifier is provided
- Checks workspace exists before attempting removal
- Provides clear error messages if workspace not found
- Handles git operation failures gracefully

## Examples of Workspace Identifiers

The identifier should match what was used when creating the workspace:

| Creation Command | Identifier for Cleanup |
|------------------|------------------------|
| `Jira-123` | `Jira-123` |
| `--suffix experiment` | `experiment` |
| `Jira-456 --suffix api-refactor` | `Jira-456` (the ticket is the identifier) |

## Related Skills

- **create-feature-workspace**: Creates new feature workspaces
- **cleanup-feature-workspace**: Removes feature workspaces (this skill)