---
name: create-project
description: "Create and validate the Java 21 Hello World project using the project-scaffold skill."
argument-hint: "Provide a project name and Java package name, for example hello-java and com.example.hello."
agent: "agent"
---

# Create Project

## Purpose

Create the minimal Java 21 Maven project described by the repository's project-scaffold skill, including the Hello World application, standard source layout, README, and `.gitignore`.

## Preconditions

- Read [.github/skills/project-scaffold/SKILL.md](../skills/project-scaffold/SKILL.md) before acting.
- Obtain a valid project name and Java package name; ask instead of guessing if either is missing.
- Inspect the repository and preserve existing user files and changes.
- Do not create Maven configuration, tests, scripts, or workflows in this operation.

## Steps

1. Read and follow `project-scaffold/SKILL.md` as the authoritative procedure.
2. Validate the project name and package name.
3. Create `src/main/java` and `src/test/java`.
4. Create the package path and a Java 21-compatible Hello World `App.java`.
5. Create or safely update `README.md` and `.gitignore`.
6. Review the diff for unrelated changes.

## Expected output

- Standard Maven source directories exist.
- `App.java` is under the requested package path and prints Hello World.
- README documents the project and Java 21 usage.
- `.gitignore` covers Maven output while preserving prior rules.

## Validation

- Verify the package declaration matches the directory path.
- Verify the `main` method and Hello World output.
- Verify both source roots exist.
- Run `git diff --check` and inspect status.
- Report exactly what was created or updated; do not claim a build unless it was run.

## Error handling

- Stop for missing or invalid inputs.
- Stop rather than overwrite conflicting user-authored files.
- Report file and command failures explicitly.
- Do not create files outside the scaffold scope or silently recover from errors.

## Idempotency rules

- Reuse existing directories and identical files.
- Add missing README or ignore content without duplicating or replacing prose.
- Preserve unrelated source and user changes.
- A repeat run must not duplicate Hello World code or documentation.
