---
description: Review current git changes with the code-reviewer subagent
agent: reviewer
subtask: true
---

Review my current git changes.

Git status:
!`git status --short`

Staged diff:
!`git diff --staged --stat && git diff --staged`

Unstaged diff:
!`git diff --stat && git diff`

Return only review findings. If there are no meaningful issues, say so clearly.
