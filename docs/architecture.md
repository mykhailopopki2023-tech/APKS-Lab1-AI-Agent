# APKS Laboratory 1 Architecture

## Overview

This repository demonstrates a Java 21 project managed through reusable GitHub Copilot customization. The `build-engineer` custom agent coordinates project scaffolding, Maven builds, JUnit 5 testing, GitHub Actions CI, and validation while preserving user changes.

## AI Agent: build-engineer

The [build-engineer agent](../.github/agents/build-engineer.agent.md) is a software build automation engineer. Its responsibilities are:

- Creating and maintaining project scaffolding.
- Configuring Apache Maven.
- Creating and running JUnit 5 tests.
- Configuring GitHub Actions CI.
- Validating the project structure, build, tests, and CI configuration.

The agent must inspect files before editing, preserve existing changes, follow repository architecture, use applicable skills, validate major operations, protect secrets, avoid destructive Git operations, and report errors honestly.

## Skills

The repository provides three reusable skills under `.github/skills/`:

### `project-scaffold`

Creates a minimal Java 21 Maven project. It accepts a project name and Java package, creates `src/main/java` and `src/test/java`, adds a Hello World `App.java`, updates `README.md`, and maintains `.gitignore` without overwriting user files.

### `build-and-test`

Configures the Java 21 Maven build and JUnit Jupiter. It creates or updates `pom.xml`, configures compiler release 21 and Surefire, adds `Calculator.java` and `BasicAdditionTest.java`, configures the executable `target/hello.jar`, and validates Maven Wrapper, compilation, tests, packaging, and JAR execution.

### `github-actions`

Configures cross-platform CI. It creates `scripts/ci.sh`, `scripts/ci.bat`, and `.github/workflows/ci.yml`; runs the Maven Wrapper with `clean verify`; tests Ubuntu, Windows, and macOS using Java 21 Temurin and Maven caching; checks `target/hello.jar`; and uploads the JAR for each operating system.

## Prompt Commands

The six reusable prompts are stored under `.github/prompts/`:

- `/git-init` — Inspects Git, branch, status, remotes, and `.gitignore`; never commits or pushes.
- `/create-project` — Reads `project-scaffold` and creates the Hello World project.
- `/create-build` — Reads `build-and-test` and creates Maven, JUnit, calculator, and executable-JAR configuration.
- `/create-actions` — Reads `github-actions` and creates the CI scripts and workflow.
- `/check` — Performs read-only configuration checks, runs `mvn clean verify`, validates CI, and checks Git status.
- `/init` — Orchestrates the complete initialization sequence.

## Initialization Order

`/init` executes the operations strictly in this order:

1. `/git-init`
2. `/create-project`
3. `/create-build`
4. `/create-actions`
5. `/check`

Each stage must succeed before the next stage begins. The orchestrator stops immediately on failure and reports the failed stage, evidence, partial changes, and required next action.

## Java, Maven, and JUnit Architecture

The application uses Java 21. Maven supplies the standard project lifecycle, dependency management, compilation, testing, packaging, and verification.

The expected source layout is:

```text
src/
├── main/java/    application sources
└── test/java/    JUnit 5 test sources
```

`pom.xml` configures Java compiler release 21, the JUnit Jupiter dependency, Maven Surefire for JUnit 5 discovery, and the Maven Jar Plugin. Packaging produces `target/hello.jar` with a `Main-Class` manifest entry so it can be launched with `java -jar`.

The Maven Wrapper (`mvnw`, `mvnw.cmd`, and `.mvn/wrapper/`) provides a reproducible Maven version across operating systems. Build commands are executed through the wrapper in CI scripts when those files are available.

## Error Handling and Validation

All operations are evidence-based:

- Inputs and existing files are checked before changes.
- Conflicting user-authored files are not overwritten automatically.
- Build and test success is reported only after command execution and result confirmation.
- `mvn clean test`, `mvn clean verify`, and `java -jar target/hello.jar` provide build, test, packaging, and runtime evidence.
- The generated JAR and its manifest are inspected.
- CI configuration is checked for triggers, the three operating-system matrix, Java 21 Temurin, Maven caching, script invocation, and artifact upload.
- Secrets are never exposed, and generated build output must remain ignored and untracked.

## Git Branching Strategy

Use `main` as the stable integration branch. Perform laboratory work on short-lived feature branches named for the task, for example:

```text
feature/project-scaffold
feature/maven-build
feature/github-actions
docs/repository-guide
```

Changes should be reviewed and validated before merging into `main`. Keep commits focused, do not force-push, and never commit secrets or generated `target/` artifacts. The `/git-init` prompt reports the current branch and status but does not commit or push automatically.
