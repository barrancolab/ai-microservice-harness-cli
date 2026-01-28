---
name: create-harness
description: Creates a new git worktree with selective submodule initialization for feature development. Use when starting work on a new ticket or feature that requires isolated harness with specific services.
---

# Create Harness

Creates a new git worktree as a sibling directory to the current harness root with selective submodule initialization for feature development.

## Parameters

- **ticket** (optional): Jira ticket ID (e.g., Jira-123, TICKET-456)
- **services** (required): One or more service names to initialize
- **change_type** (optional): Branch type prefix - default: "feat"
  - Common values: feat, fix, chore, refactor, docs
- **suffix** (optional): Additional suffix for branch name or harness identifier
  - When ticket provided: Creates branch `<TICKET>-<change_type>/<suffix>`
  - When no ticket: Uses suffix as harness identifier
- **purpose** (optional): Description for the feature/change being implemented
- **status** (optional): Current harness status (default: "Feature Development")
- **goal** (optional): Current harness goal (default: "Use skills in ./.claude/skills to generate new feature/change harnesses")
- **solution_patterns** (optional): Comma-separated solution patterns for the harness
- **implementation_patterns** (optional): Comma-separated implementation patterns for the harness

## Process

1. **Validate inputs**: Check service names exist as submodules
2. **Calculate paths**: Determine worktree path 
   - With ticket: `../{current-harness-name}-<TICKET>`
   - Without ticket: `../{current-harness-name}-<SUFFIX>`
   - Example: If current directory is "ai-microservice-harness-cli":
     - With ticket: "../ai-microservice-harness-cli-harness-Jira-123"
     - Without ticket: "../ai-microservice-harness-cli-harness-api-refactor"
3. **Create worktree**: Use `git worktree add` to create new harness
4. **Initialize submodules**: Only initialize specified services, leaving others empty
5. **Create feature branches**: In each submodule, create branch from configured/default branch
6. **Generate documentation**: Create HARNESS_SCOPE.md with harness details

## Branch Naming

- **With ticket, no suffix**: `<TICKET>-<change_type>` (e.g., `Jira-123-feat`)
- **With ticket and suffix**: `<TICKET>-<change_type>/<suffix>` (e.g., `Jira-789-feat/api-refactor`)
- **Without ticket, with suffix**: `<suffix>` (e.g., `api-refactor`)


## Usage Examples

**Basic feature harness with ticket:**
```
Create harness for Jira-123 with rgl-node-sync-api and rgl-node-etl-document-delta-app services
```

**Fix with specific change type:**
```
Create harness for Jira-456 with change_type 'fix' for rgl-node-sync-api service
```

**Feature with suffix and ticket:**
```
Create harness for Jira-789 with change_type 'feat', suffix 'api-refactor', for rgl-node-sync-api service
```

**Feature with full context:**
```
Create harness for Jira-999 with status 'API Development', goal 'Implement new user authentication endpoints', solution_patterns 'JWT pattern, Database pattern', implementation_patterns 'Repository pattern, Service layer pattern', for rgl-node-sync-api service
```

**Harness without ticket (using suffix as identifier):**
```
Create harness with suffix 'experiment' and rgl-node-sync-api service
```

## Generated HARNESS_SCOPE.md

The skill automatically generates a HARNESS_SCOPE.md file that matches the main harness format, containing:

- **Current Harness section**: Status and Goal
- **Active Submodules section**: List of initialized services with branch info
- **Solution Patterns in Scope section**: Available solution patterns
- **Common Implementation Patterns section**: Available implementation patterns  
- **Session Goals section**: Uses the purpose parameter
- **Notes section**: Creation timestamp and harness metadata

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

The skill executes `.claude/skills/create-harness/scripts/new-harness.sh` with the parsed parameters:

```bash
# Basic usage with ticket
./.claude/skills/create-harness/scripts/new-harness.sh Jira-123 service1 service2

# With change type and suffix and purpose
./.claude/skills/create-harness/scripts/new-harness.sh Jira-456 --change-type fix --suffix bug-fix --purpose "Fix the bug for cache warm requests in the viewResource.ts controller file." service1 

# Without ticket, using suffix as identifier
./.claude/skills/create-harness/scripts/new-harness.sh --suffix experiment service1 service2

# With full context (example for AI agents)
./.claude/skills/create-harness/scripts/new-harness.sh Jira-999 \
  --change-type feat \
  --suffix auth-endpoints \
  --purpose "Implement new user authentication endpoints" \
  --status "API Development" \
  --goal "Implement new user authentication endpoints" \
  --solution-patterns "JWT pattern, Database pattern" \
  --implementation-patterns "Repository pattern, Service layer pattern" \
  rgl-node-sync-api

# Show help
./.claude/skills/create-harness/scripts/new-harness.sh --help
```

The script handles color output, error validation, worktree creation, submodule initialization, branch creation, and harness documentation generation.

## Cleanup

To remove a created harness, use the `cleanup-harness` skill:

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
3. Begin development work
