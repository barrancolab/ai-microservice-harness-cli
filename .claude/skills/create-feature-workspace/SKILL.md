---
name: create-feature-workspace
description: Creates a new git worktree with selective submodule initialization for feature development. Use when starting work on a new ticket or feature that requires isolated harness with specific services.
---

# Create Feature Workspace

Creates a new git worktree as a sibling directory to the current harness root with selective submodule initialization for feature development.

## Parameters

- **ticket** (optional): Jira ticket ID (e.g., Jira-123, TICKET-456)
- **services** (required): One or more service names to initialize
- **change_type** (optional): Branch type prefix - default: "feat"
  - Common values: feat, fix, chore, refactor, docs
- **suffix** (optional): Additional suffix for branch name or harness identifier
  - When ticket provided: Creates branch `<TICKET>-<change_type>/<suffix>`
  - When no ticket: Uses suffix as harness identifier

## Process

1. **Validate inputs**: Check service names exist as submodules
2. **Calculate paths**: Determine worktree path 
   - With ticket: `../{current-harness-name}-harness-<TICKET>`
   - Without ticket: `../{current-harness-name}-harness-<SUFFIX>`
   - Example: If current directory is "ai-microservice-harness-cli":
     - With ticket: "../ai-microservice-harness-cli-harness-Jira-123"
     - Without ticket: "../ai-microservice-harness-cli-harness-api-refactor"
3. **Create worktree**: Use `git worktree add` to create new harness
4. **Initialize submodules**: Only initialize specified services, leaving others empty
5. **Create feature branches**: In each submodule, create branch from configured/default branch
6. **Generate documentation**: Create WORKSPACE_SCOPE.md with harness details

## Branch Naming

- **With ticket, no suffix**: `<TICKET>-<change_type>` (e.g., `Jira-123-feat`)
- **With ticket and suffix**: `<TICKET>-<change_type>/<suffix>` (e.g., `Jira-789-feat/api-refactor`)
- **Without ticket, with suffix**: `<suffix>` (e.g., `api-refactor`)

## Harness Structure

```
../{current-harness-name}-harness-<IDENTIFIER>/
├── WORKSPACE_SCOPE.md          # Generated harness documentation
├── .gitmodules                 # Copied from parent harness
├── service1/                   # Initialized with feature branch
├── service2/                   # Initialized with feature branch
├── other-service/              # Empty (not initialized)
└── ...

Where <IDENTIFIER> is either the ticket ID or suffix if no ticket is provided.
```

## Usage Examples

**Basic feature harness with ticket:**
```
Create feature harness for Jira-123 with rgl-node-sync-api and rgl-node-etl-document-delta-app services
```

**Fix with specific change type:**
```
Create feature harness for Jira-456 with change_type 'fix' for rgl-node-sync-api service
```

**Feature with suffix and ticket:**
```
Create feature harness for Jira-789 with change_type 'feat', suffix 'api-refactor', for rgl-node-sync-api service
```

**Harness without ticket (using suffix as identifier):**
```
Create feature harness with suffix 'experiment' and rgl-node-sync-api service
```

## Generated WORKSPACE_SCOPE.md

The skill automatically generates a WORKSPACE_SCOPE.md file containing:

- Creation timestamp
- List of active services
- Branch information table (Service | Branch | Base)
- Purpose section (to be filled by user)
- Related Jira link
- Usage notes

## Error Handling

- Validates worktree doesn't already exist
- Checks all specified services are valid submodules
- Handles branch creation conflicts
- Provides clear error messages with resolution suggestions

## Implementation Details

### Worktree Creation Logic

1. **Primary attempt**: `git worktree add <path> -b <branch>`
2. **Fallback 1**: `git worktree add <path> <branch>` (if branch exists)
3. **Fallback 2**: Create detached worktree, then checkout branch

### Submodule Branch Creation

For each service:
1. Read configured branch from `.gitmodules` (submodule.<service>.branch)
2. Fallback to default branch if not configured
3. Fetch latest from origin
4. Create feature branch from base branch
5. Push to origin with upstream tracking

### Service Validation

Lists all available submodules using `git submodule status` and validates each requested service exists.

### Script Usage

The skill executes `.claude/skills/create-feature-workspace/scripts/new-feature-workspace.sh` with the parsed parameters:

```bash
# Basic usage with ticket
./.claude/skills/create-feature-workspace/scripts/new-feature-workspace.sh Jira-123 service1 service2

# With change type and suffix
./.claude/skills/create-feature-workspace/scripts/new-feature-workspace.sh Jira-456 --change-type fix --suffix bug-fix service1

# Without ticket, using suffix as identifier
./.claude/skills/create-feature-workspace/scripts/new-feature-workspace.sh --suffix experiment service1 service2

# Show help
./.claude/skills/create-feature-workspace/scripts/new-feature-workspace.sh --help
```

The script handles color output, error validation, worktree creation, submodule initialization, branch creation, and harness documentation generation.

## Cleanup

To remove a created harness, use the `cleanup-feature-workspace` skill:

```
Cleanup harness <IDENTIFIER>
```

The cleanup skill will safely remove the harness directory and associated git branch with proper confirmation prompts.

**Examples**:
```
Cleanup harness Jira-123
Cleanup harness experiment
```


## Next Steps After Creation

1. `cd ../{current-harness-name}-harness-<IDENTIFIER>`
2. Open in IDE (if available)
3. Update WORKSPACE_SCOPE.md with feature details
4. Begin development work
