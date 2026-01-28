---
name: cleanup-harness
description: Removes a feature harness created by the create-harness skill. Use when you need to clean up harnesses that are no longer needed.
---

# Cleanup Harness

Safely removes a feature harness created by the `create-harness` skill, including both the worktree directory and associated git branch.

## Parameters

- **identifier** (required): Harness identifier (ticket ID or suffix used when creating the harness)

## Process

1. **Validate identifier**: Check that harness exists
2. **Confirm deletion**: Show what will be removed and require user confirmation
3. **Remove worktree**: Use `git worktree remove` to safely remove the worktree
4. **Remove branch**: Delete the associated git branch if it exists
5. **Report results**: Confirm successful removal

## Usage Examples

**Remove harness for a ticket:**
```
Cleanup harness Jira-123
```

**Remove harness created with suffix:**
```
Cleanup harness experiment
```

**Remove harness with complex identifier:**
```
Cleanup harness api-migration-phase-1
```

## Script Execution

The skill executes `.claude/skills/cleanup-harness/scripts/cleanup-harness.sh` with the harness identifier.

## Safety Features

- **Confirmation prompt**: Requires explicit user confirmation before deletion
- **Validation**: Checks harness exists before attempting removal
- **Git safety**: Uses proper git worktree removal to avoid repository corruption
- **Clear feedback**: Shows exactly what will be removed before confirming

## What Gets Removed

1. **Worktree directory**: The harness directory (e.g., `../{harness-name}-harness-{identifier}/`)
2. **Git branch**: The worktree branch (e.g., `{identifier}-workspace`)
3. **All harness contents**: Including generated documentation and any local changes

## Important Notes

- **Run from main harness**: Execute this skill from your main harness, not from the harness being removed
- **Backup important changes**: Ensure any work you want to keep is pushed or backed up before cleanup
- **Irreversible**: Cleanup permanently removes the harness and branch
- **Only removes harnesses**: Will not affect other directories or branches

## Error Handling

- Validates identifier is provided
- Checks harness exists before attempting removal
- Provides clear error messages if harness not found
- Handles git operation failures gracefully

## Examples of Harness Identifiers

The identifier should match what was used when creating the harness:

| Creation Command | Identifier for Cleanup |
|------------------|------------------------|
| `Jira-123` | `Jira-123` |
| `--suffix experiment` | `experiment` |
| `Jira-456 --suffix api-refactor` | `Jira-456` (the ticket is the identifier) |

## Related Skills

- **create-harness**: Creates new feature harnesses
- **cleanup-harness**: Removes feature harnesses (this skill)
