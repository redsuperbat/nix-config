---
name: pr
description: Create a pull request for the current branch
disable-model-invocation: true
allowed-tools: Bash(gh:*), Bash(git:*)
---

1. Fetch origin and rebase the current branch onto `origin/main`. Resolve any conflicts before proceeding.
2. Push the branch if needed.
3. Create a pull request using `gh pr create` with a clear title and description summarizing the changes.
