---
name: pr
description: Create a pull request for the current branch. Use when the user asks to open, create, or submit a PR, or run /pr.
---

# Create a pull request

1. Fetch origin and rebase the current branch onto `origin/main`. Resolve any conflicts before proceeding.
2. Push the branch if needed.
3. Create a pull request using `gh pr create` with a clear title and description summarizing the changes.
4. Return the PR URL when done.
