---
name: create-build
description: "Configure and validate the Java 21 Maven/JUnit 5 build using the build-and-test skill."
argument-hint: "Optionally provide the fully qualified application entry point for hello.jar."
agent: "agent"
---

# Create Build

## Purpose

Create the Maven build configuration and calculator test setup for Java 21, JUnit Jupiter, Surefire, Maven Wrapper, and the executable `target/hello.jar`.

## Preconditions

- Read [.github/skills/build-and-test/SKILL.md](../skills/build-and-test/SKILL.md) before acting.
- Confirm the Java package and fully qualified `Main-Class`.
- Confirm the project scaffold and application entry point exist.
- Inspect `pom.xml`, sources, tests, wrapper files, and user changes first.
- Do not create CI workflows or scripts in this operation.

## Steps

1. Follow `build-and-test/SKILL.md` as the authoritative procedure.
2. Create or safely update `pom.xml` for Java release 21, JUnit Jupiter, Surefire, and `hello.jar`.
3. Create `Calculator.java` with an addition method.
4. Create `BasicAdditionTest.java` using JUnit 5 assertions.
5. Create or preserve Maven Wrapper files where available.
6. Run the required Maven lifecycle and JAR commands from the skill.
7. Inspect the JAR contents and manifest.

## Expected output

- Maven compiles for release 21.
- JUnit Jupiter discovers and executes `BasicAdditionTest`.
- `target/hello.jar` has the correct `Main-Class`.
- Maven Wrapper files are present or their unavailability is reported.

## Validation

Run and report:

- `mvn clean test`
- `mvn clean verify`
- `java -jar target/hello.jar`
- JAR contents and manifest checks.

Confirm the actual exit status and test results. Never claim tests or packaging passed without execution.

## Error handling

- Stop for an absent or conflicting application entry point.
- Preserve compatible existing Maven configuration and user files.
- Report dependency, compilation, test, packaging, wrapper, and JAR failures explicitly.
- Do not skip tests, ignore errors, or claim success after a failed command.

## Idempotency rules

- Merge missing Maven configuration instead of replacing unrelated settings.
- Do not duplicate dependencies, plugins, calculator methods, or tests.
- Preserve an existing compatible wrapper and entry point.
- Re-run validation after any change or no-op determination.
