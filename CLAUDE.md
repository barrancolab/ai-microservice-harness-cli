# Claude Configuration

This file contains configuration for Claude AI coding agents working with this harness system.

## Skills Import

Import the current harness scope and available skills:

```markdown
<!-- Import harness scope -->
./HARNESS_SCOPE.md
```

## Available Directories

- `skills/`: AI-codable skills for harness operations
- `solution_patterns/`: Progressive disclosure markdown for common solution patterns with the microservices in ./submodules/ directory
- `submodules/`: Git submodules (when active) - these are the underlying codebases/repositories

## Working with Submodules

When submodules are active, Claude can:
- Navigate to submodule directories
- Apply changes across multiple repositories
- Use solution patterns for consistent implementations

## Harness Commands

The harness CLI provides improved ergonomics for:
- Git worktree management
- Submodule operations
- Harness setup and teardown
