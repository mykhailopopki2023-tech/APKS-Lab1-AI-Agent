---
name: git-init
description: "Inspect and safely initialize the repository's Git state and .gitignore without committing or pushing."
argument-hint: "Optionally provide the repository root or additional ignore requirements."
agent: "agent"
---

# Git Initialization

## Purpose

Inspect the repository's Git state and prepare a safe, appropriate `.gitignore` for the Java 21, Maven, and JUnit 5 project. This prompt must never commit or push changes automatically.

## Preconditions

- Work from the repository root.
- Inspect files and existing user changes before editing.
- Confirm that Git and the repository path are available.
- Do not assume that an absent `.git` directory can be created without checking the user's intent.

## Steps

1. Check whether a Git repository exists with a non-destructive Git command.
2. Inspect `git status --short --branch`, the current branch, repository root, and configured remotes without exposing credentials.
3. Read any existing `.gitignore` and identify tracked or untracked build artifacts.
4. Create or safely update `.gitignore` with appropriate Java/Maven/IDE and build-output rules, preserving existing rules and user content.
5. Re-check status and report repository information, changed paths, branch, and ignored build-file behavior.
6. Do not run `git commit`, `git push`, reset, checkout, clean, or other destructive Git operations.

## Expected output

Report:

- Whether a Git repository exists.
- Repository root and current branch.
- Safe remote summary, excluding tokens or credentials.
- Initial and final status.
- Whether `.gitignore` was created or updated.
- Any limitations or actions requiring user approval.

## Validation

- Confirm `.gitignore` exists when the operation was able to create it.
- Confirm expected Maven output such as `target/` is ignored without hiding source files.
- Run `git diff --check` when changes were made.
- Confirm no commit, push, or destructive Git operation was performed.

## Error handling

- Report command failures with the command and relevant error.
- Stop if the repository root is ambiguous or an existing user-authored `.gitignore` has a conflict that cannot be merged safely.
- Never expose secrets from remotes or configuration.
- Do not claim initialization succeeded unless the repository state was inspected and verified.

## Idempotency rules

- Reuse an existing repository and `.gitignore`.
- Add only missing ignore rules.
- Never duplicate rules or overwrite unrelated content.
- A second run with no new requirements must produce no functional changes.
