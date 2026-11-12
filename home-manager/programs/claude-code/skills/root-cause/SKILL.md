---
name: root-cause
description: Find the root cause of an error (stack trace, log line, failing test or CI output) pasted after the skill invocation, and report it without fixing anything
disable-model-invocation: true
---

The error to investigate:

$ARGUMENTS

If no error was given above, ask for it and stop.

1. Parse the error: the message, error type/code, the top frames that point into this repository (skip framework and `node_modules` frames), and any ids, timestamps, service or environment named in it.
2. Locate where it is thrown or logged. Grep for the exact message text and error class, then read the code at each relevant frame. Do not guess from names alone.
3. Trace backwards from the throw site: which caller passed what, where that value came from, and which condition must have held for this path to run. Follow it until you reach the first point where the state became wrong. That point, not the throw site, is the root cause.
4. Check whether it is new: `git log -p -S '<key identifier>'` and `git log` on the involved files to find recent changes that introduced or exposed it.
5. Verify the hypothesis before reporting. Prefer a concrete check: reproduce with a test or script, run the failing command, or query logs/data if the error names ids. If you can't verify it, say so and state what would confirm it. If evidence contradicts the hypothesis, go back to step 3 rather than bending the explanation.
6. Do not change code. This skill only diagnoses.

Report, briefly:

- **Root cause**: one or two sentences, with `file:line` references.
- **Chain**: the short sequence from root cause to the observed error.
- **Evidence**: what you checked and what confirmed it (or what is still unverified).
- **Introduced by**: commit/PR if found.
- **Fix options**: one to three concrete fixes, recommended one first. Note if the error message itself is misleading.
