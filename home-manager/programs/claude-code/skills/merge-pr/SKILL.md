---
name: merge-pr
description: Wait until the current branch's PR has passing CI and an approval, merge it, then remove the worktree with workmux
disable-model-invocation: true
allowed-tools: Bash(gh:*), Bash(git:*), Bash(workmux:*), Bash(until:*)
---

1. Find the PR for the current branch with `gh pr view --json number,url,state`. Stop if there is none or it is not open.
2. Make sure the worktree is clean (`git status --porcelain`) and pushed. Stop and ask if there are uncommitted or unpushed changes.
3. Wait for CI with `gh pr checks --watch --fail-fast` (run in the background). If any check fails, read its log (`gh run view --log-failed`):
   - Failing test or static analysis (lint, type check, format): fix it, commit, push, and restart from step 1. Give up and report after 3 fix attempts.
   - Anything else (infra, flaky runner, deploy, secrets): stop and report which check failed.
4. Wait for approval by polling in the background:
   `until [ "$(gh pr view --json reviewDecision -q .reviewDecision)" = APPROVED ]; do sleep 60; done`
   If the decision becomes `CHANGES_REQUESTED`, stop and report the review.
5. Re-check that CI is still green and the PR is still approved (new pushes reset both), then merge with `gh pr merge --squash`. Do not pass `--delete-branch`: it tries to check out main, which fails inside a worktree.
6. Confirm the merge with `gh pr view --json state` (expect `MERGED`).
7. As the very last step, run `workmux remove -f` from the worktree. This closes this tmux window, so report the PR URL before running it.
