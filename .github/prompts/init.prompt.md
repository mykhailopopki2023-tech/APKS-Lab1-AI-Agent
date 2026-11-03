---
name: init
description: "Orchestrate complete repository initialization in the required Git, project, build, CI, and check sequence."
argument-hint: "Provide the project name and Java package name before starting."
agent: "agent"
---

# Initialize Project

## Purpose

Act as the main orchestrator for the complete Java 21, Maven, and JUnit 5 laboratory setup. Coordinate the five focused prompts in order and produce a detailed execution report.

## Preconditions

- Obtain a project name and Java package name.
- Read the five focused prompt files before invoking them.
- Confirm the repository root and preserve existing user changes.
- Do not create source, Maven, script, or workflow files directly from this prompt; delegate each stage.

## Steps

Execute these operations exactly in sequence:

1. Invoke `/git-init`.
2. If and only if `git-init` succeeds, invoke `/create-project`.
3. If and only if `create-project` succeeds, invoke `/create-build`.
4. If and only if `create-build` succeeds, invoke `/create-actions`.
5. If and only if `create-actions` succeeds, invoke `/check`.

After each operation:

- Capture its result, changed paths, validation evidence, and errors.
- Stop immediately if the stage fails.
- Do not start a later stage after a failure.
- Do not hide or reinterpret a failed or unverified result as success.

## Expected output

Produce a detailed report containing:

- Inputs and repository information.
- A stage-by-stage result for `git-init`, `create-project`, `create-build`, `create-actions`, and `check`.
- Files created or updated by each successful stage.
- Commands executed and their confirmed results.
- Maven test/build results, JAR evidence, and CI validation.
- The exact stopping point and required user action if any stage fails.

## Validation

- Confirm the five operations were attempted in the required order.
- Confirm later stages were not attempted after a failure.
- Use the `check` stage's read-only results as the final verification.
- Never claim complete initialization unless every stage succeeded and the final check confirmed it.

## Error handling

- Stop immediately on any failed command, invalid input, conflict, or unverified required result.
- Preserve all user changes made before the failure.
- Do not retry by deleting or resetting files.
- Report the failed stage, exact error, partial changes, and safe next step.
- Never commit or push automatically.

## Idempotency rules

- Each delegated prompt must follow its own idempotency rules.
- Before invoking a stage, allow it to inspect and safely reuse existing files.
- Do not invoke a successful stage repeatedly within the same orchestration.
- A rerun after failure must begin with inspection and must not overwrite user-authored files.
