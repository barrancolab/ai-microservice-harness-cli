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

## How to use this repository

### 1. Set up your harness repository
- Fork this repository or create your own harness repository using this repo as a template
- Clone your new harness repository locally

### 2. Add microservice repositories
- Use the "add-submodule" skill to add your microservice repo to the `submodules/` folder
- Or, run the required git commands to add the submodule to the `submodules/` directory
- Repeat this process for each microservice you want to include
- Commit the submodules and `.gitmodules` file to your version control

### 3. Create a new feature harness
- When ready to work on a new feature, use the "new-harness" skill
- Provide a JIRA issue ID or short description of the change
- More detail is better! If you can provide a clear and conscise PRD, do it! It will automatically be inserted into the new harness's `HARNESS_SCOPE.md` file.
- The harness will be automatically named based on your inputs
- The new harness is automatically created at the same directory level as your locally cloned "clean" repository. Try creating a new harness with this repo!

### 4. Start development
- Change directories to the new harness location or open it in your editor
- The `CLAUDE.md` file will reference the `HARNESS_SCOPE.md` file
- Begin implementing the feature outlined in the harness scope specifications
- Each submodule will have a feature branch created during harness creation, allowing individual pull requests per repository

### 5. Clean up when complete
- Return to the "clean" harness directory
- Use the "clean-harness" skill to remove all data related to that feature work

## Getting Started

See [HARNESS_SCOPE.md](./HARNESS_SCOPE.md) for the current harness configuration and goals.

## Skills

The `.claude/skills/` directory contains AI-codable skills that can be used to interact with this harness system.

## Solution Patterns

The `solution_patterns/` directory contains documented patterns for common microservice integration challenges.
