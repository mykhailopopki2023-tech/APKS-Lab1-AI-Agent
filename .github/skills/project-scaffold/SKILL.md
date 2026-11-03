---
name: project-scaffold
description: "Use when creating or completing a minimal Java 21 Maven project. Accept a project name and Java package name, create the standard source layout and Hello World application, and maintain README.md and .gitignore without overwriting user files."
---

# Project Scaffold

## Purpose

Provide a repeatable, safe procedure for creating a minimal Java 21 project managed by Apache Maven. The resulting scaffold must have a conventional Maven source layout, a runnable `App.java`, basic project documentation, and an appropriate Git ignore file.

This skill describes file creation for a future scaffold operation. It does not itself create application files unless an agent invokes it for a user request.

## When to use

Use this skill when a user asks to:

- Start a new minimal Java 21 project.
- Scaffold a Maven Java application.
- Add the missing standard Maven structure to an otherwise empty project.
- Create a Hello World Java application with project documentation.

Do not use it to add tests, CI workflows, application features, or dependencies beyond the minimal scaffold unless the user separately requests those changes.

## Inputs

Before making changes, obtain or confirm:

1. **Project name**: A filesystem-safe and Maven-compatible name, such as `hello-java`.
2. **Java package name**: A valid dot-separated package name, such as `com.example.hello`.
3. **Project root**: The repository or directory where the scaffold belongs.

If either the project name or package name is missing, ask for it rather than guessing. Validate that:

- The project name is non-empty and does not contain path separators or characters unsafe for the target filesystem.
- The package name contains valid Java identifiers separated by dots.
- The package name does not begin or end with a dot and does not contain empty components.

Inspect the project root and relevant existing files before modifying anything. Identify user-authored files, existing Maven files, source files, README content, ignore rules, and untracked changes.

## Outputs

When invoked successfully, produce:

- A standard Maven directory `src/main/java`.
- A standard Maven directory `src/test/java`, left ready for future tests.
- `src/main/java/<package path>/App.java`, containing a minimal Java 21 Hello World application in the requested package.
- A `README.md` describing the project name, Java 21 requirement, Maven usage, and how to run the application.
- A `.gitignore` covering Maven build output and common Java/IDE-generated files without removing existing rules.

Do not create unrelated files, dependencies, tests, CI workflows, or build artifacts.

## Execution procedure

1. Inspect the project root and record the current state before editing.
2. Confirm the project name and package name from the inputs.
3. Convert the package name to a source path by replacing each `.` with the platform path separator. For example, `com.example.hello` becomes `com/example/hello`.
4. Create `src/main/java` and `src/test/java` if they do not exist.
5. Create the package directory under `src/main/java`.
6. Create `App.java` in that package directory with:
   - The matching `package` declaration.
   - A public `App` class.
   - A `public static void main(String[] args)` method.
   - A simple `System.out.println` Hello World message.
   - No external dependencies.
7. Create or update `README.md`:
   - Preserve meaningful existing content.
   - Add only missing project details.
   - Document Java 21 as the required runtime.
   - Document Maven commands for compiling and running the application.
8. Create or update `.gitignore`:
   - Preserve existing ignore rules.
   - Add Maven output such as `target/`.
   - Add common Java/IDE output only when it is not already covered.
   - Never add secrets, credentials, or broad rules that could hide source files.
9. Review the complete change set and ensure only the intended scaffold files were added or updated.

This skill does not require creating a `pom.xml`; Maven configuration is handled by a separate project task unless the user explicitly requests it.

## Validation

Validate the scaffold after execution:

1. Confirm `src/main/java` and `src/test/java` exist.
2. Confirm `App.java` is under the exact package path and its package declaration matches the requested package.
3. Confirm the application contains a valid `main` method and Hello World output.
4. Confirm `README.md` mentions the project, Java 21, and Maven usage.
5. Confirm `.gitignore` includes `target/` and retains prior rules.
6. If a Maven project configuration exists, run the smallest applicable Maven validation, such as `mvn test`; otherwise report that Maven compilation could not be run because no `pom.xml` exists.
7. Inspect version-control status and diff checks. Ensure no build artifacts, secrets, or unrelated files are included.

Report the exact validation commands and their outcomes. Do not claim that the application builds or tests pass unless the commands were actually run successfully.

## Error handling

- Stop before editing when required inputs are missing or invalid, and request corrected values.
- Stop and report the conflict if an existing file at a required path contains user content that would be overwritten.
- Preserve existing files when an update can be made safely; merge additions instead of replacing content.
- If directory creation, file writing, validation, or a command fails, report the operation, error, and affected path.
- Do not hide errors with broad exception handling, silent fallbacks, or success-shaped output.
- Do not delete or reset files to recover from an error. Ask for approval if manual conflict resolution is required.

## Idempotency

Running this skill repeatedly with the same inputs must not duplicate content or change unrelated files:

- Reuse existing directories.
- Leave an identical `App.java` unchanged.
- Add README sections only when missing, and preserve existing prose.
- Add only missing `.gitignore` rules, preserving order and existing user rules where practical.
- Do not overwrite conflicting user-authored files automatically.
- Re-run validation after determining that no changes are necessary.

## Example usage

User request:

> Create a minimal Java 21 Maven project named `hello-java` using package `com.example.hello`.

Expected scaffold paths:

```text
hello-java/
├── .gitignore
├── README.md
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/example/hello/App.java
│   └── test/
│       └── java/
```

The agent should inspect existing files first, create only missing or safely mergeable files, then validate the paths and report whether Maven validation was possible.
