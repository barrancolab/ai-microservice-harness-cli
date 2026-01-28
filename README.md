# ai-microservice-harness

This project provides a set of tools targeted at making developing many interconnected microservices easier.

## Features

1. **Providing structure**: The repo's root directory is a "clean room" where only meta-resources are stored
2. **Quality of Life Improvements on CLI Interface**: Abstracts away git worktrees and submodules ergonomics
3. **AI Tools**: Tools specifically targeted at being invoked by AI coding agents

## Directory Structure

```
harness-repo/
├── .claude/
│   └── skills/
│       └── new-harness/
│           └── SKILL.md
├── submodules/          # Git submodules for microservices (when active)
├── solution_patterns/   # Progressive disclosure .md files
│   ├── README.md
│   ├── schema-updates.md
│   ├── customer-specific-registration.md
│   └── sync-requests_2_async-workers.md
├── scripts/            # Utility scripts
│   ├── add-new-submodule-to-harness.sh
│   ├── delete-submodule-branches.sh
│   ├── new-harness-worktree.sh
│   └── new-submodule-branch.sh
├── CLAUDE.md           # AI tooling configuration
├── HARNESS_SCOPE.md    # Current harness scope and goals
├── INITIALIZE_REPO.md  # Repository initialization guide
├── README.md
└── .gitmodules
```

## Getting Started

See [HARNESS_SCOPE.md](./HARNESS_SCOPE.md) for the current harness configuration and goals.

## Skills

The `.claude/skills/` directory contains AI-codable skills that can be used to interact with this harness system.

## Solution Patterns

The `solution_patterns/` directory contains documented patterns for common microservice integration challenges.
