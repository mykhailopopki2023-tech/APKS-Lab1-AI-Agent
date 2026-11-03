---
name: build-and-test
description: "Use when configuring, building, testing, packaging, or validating a Java 21 Maven project with JUnit 5. Creates the Maven build, calculator example, runnable hello.jar, and reproducible Maven Wrapper workflow."
---

# Build and Test

## Purpose

Provide a repeatable procedure for configuring and validating a Java 21 project with Apache Maven and JUnit Jupiter. The procedure creates a complete Maven build, a small calculator example with an addition test, a runnable JAR named `hello.jar`, and Maven Wrapper support for reproducible builds across Windows, Linux, and macOS.

This skill describes a future build-and-test operation. It does not itself create `pom.xml`, Java source files, tests, or wrapper files unless an agent invokes it for a user request.

## When to use

Use this skill when a user asks to:

- Add or repair Maven configuration for a Java 21 project.
- Configure JUnit 5 (JUnit Jupiter) tests.
- Create or validate a calculator addition example.
- Package a runnable JAR named `hello.jar`.
- Add Maven Wrapper support.
- Run the project’s clean, compile, test, package, or verify lifecycle.
- Check the generated JAR and its manifest.

Do not use it to create general project scaffolding, CI workflows, unrelated application features, or dependencies beyond those required by this procedure.

## Inputs

Before editing, obtain or confirm:

1. **Project root**: The repository directory containing, or intended to contain, the Maven project.
2. **Java package name**: The package used by `Calculator.java`, `BasicAdditionTest.java`, and the application entry point.
3. **Application entry point**: The fully qualified class whose `main` method should be used as the JAR `Main-Class`. If the scaffold already has `App.java`, use that class; otherwise ask for the intended entry point rather than guessing.
4. **Maven Wrapper availability**: Whether `mvnw`/`mvnw.cmd` and `.mvn/wrapper/` already exist, or whether the environment can run `mvn wrapper:wrapper`.

Inspect the repository before modifying it. Check existing `pom.xml`, source files, tests, wrapper files, README documentation, generated `target/` output, and user changes. Preserve unrelated work.

## Outputs

When invoked successfully, produce or safely update:

- `pom.xml` for Java 21 compilation, JUnit Jupiter testing, Surefire execution, and JAR packaging.
- `Calculator.java` with a clearly named addition method that returns the sum of two numeric inputs.
- `BasicAdditionTest.java` using JUnit Jupiter assertions to verify the addition method.
- Maven Wrapper files (`mvnw`, `mvnw.cmd`, and `.mvn/wrapper/` files) when wrapper creation is requested and available.
- A runnable `target/hello.jar` whose manifest contains the correct `Main-Class`.
- Only the requested build and test configuration; do not overwrite unrelated user files.

## Dependencies

Use the following technology stack:

- Java 21.
- Apache Maven.
- JUnit 5 through the JUnit Jupiter API and engine, preferably via the `org.junit.jupiter:junit-jupiter` aggregate dependency.
- Maven Surefire Plugin configured to run JUnit Platform tests.
- Maven Jar Plugin configured to write `Main-Class` in the JAR manifest.

Use a current, compatible Maven Compiler Plugin and Surefire Plugin version supported by the project’s dependency policy. Keep versions explicit and consistent with existing repository conventions. Use test scope for JUnit dependencies.

## Execution procedure

1. Inspect the project and record its current version-control state. Read existing build and source files before editing.
2. Confirm the Java package and fully qualified application entry point. Do not invent a conflicting package or overwrite a user-authored entry point.
3. Create or update `pom.xml` with:
   - Appropriate Maven coordinates and the project’s existing coordinates when present.
   - Java compiler release set explicitly to `21`, using Maven Compiler Plugin configuration such as `<maven.compiler.release>21</maven.compiler.release>`.
   - `org.junit.jupiter:junit-jupiter` in test scope.
   - Maven Surefire Plugin configured for JUnit Platform execution. Use a modern Surefire version compatible with JUnit 5 and Java 21.
   - Maven Jar Plugin configuration that sets `<mainClass>` to the confirmed fully qualified entry point and produces `hello.jar`.
4. Configure the JAR name deterministically. Prefer a final artifact name of `hello` so Maven produces `target/hello.jar`, while retaining the project’s existing artifact identity unless changing it is required.
5. Create `src/main/java/<package path>/Calculator.java` with a public addition method. Keep it dependency-free and deterministic; for integer inputs, use a signature such as `public int add(int left, int right)`.
6. Create `src/test/java/<package path>/BasicAdditionTest.java` with JUnit Jupiter:
   - Import `org.junit.jupiter.api.Test` and an appropriate Jupiter assertion.
   - Exercise `Calculator.add` with representative values.
   - Assert the exact expected sum.
   - Use the same package as the class under test unless repository conventions require otherwise.
7. Ensure the configured `Main-Class` exists, has a valid `public static void main(String[] args)` method, and is included in the compiled output. If it does not exist, stop and report the required correction instead of producing a misleading runnable-JAR configuration.
8. Configure Maven Wrapper when it is available:
   - Prefer the project’s approved Maven version.
   - Run `mvn wrapper:wrapper` from the project root when the wrapper is absent and Maven is installed.
   - Confirm that `mvnw`, `mvnw.cmd`, and `.mvn/wrapper/maven-wrapper.properties` are present.
   - Preserve existing wrapper files unless an explicit update is requested.
9. Run the required lifecycle commands from the project root:
   - `mvn clean test`
   - `mvn clean verify`
   - `java -jar target/hello.jar`
10. When the Maven Wrapper is available, also document and use the platform-appropriate commands:
    - Windows PowerShell or Command Prompt: `.\mvnw.cmd clean test`, `.\mvnw.cmd clean verify`
    - Unix-like shells: `./mvnw clean test`, `./mvnw clean verify`
11. Check the generated JAR:
    - Confirm `target/hello.jar` exists.
    - Inspect its contents with `jar tf target/hello.jar`.
    - Inspect the manifest with `jar xf` into a temporary location or an equivalent non-destructive command, and confirm `Main-Class` matches the configured entry point.
    - Run `java -jar target/hello.jar` and confirm its exit status and expected output.
12. Review the diff and status. Do not include `target/`, temporary extraction directories, secrets, or unrelated files in the result.

## Validation

Validation is evidence-based and must include:

1. `mvn clean test` completes successfully and reports the expected JUnit test result.
2. `mvn clean verify` completes successfully, including tests and packaging.
3. `target/hello.jar` exists after packaging.
4. `jar tf target/hello.jar` includes the configured entry-point class and expected application classes.
5. The manifest contains the exact `Main-Class` value.
6. `java -jar target/hello.jar` starts the application successfully and returns exit code zero.
7. The addition test verifies the expected result and is actually executed by Surefire.
8. If wrapper files exist, the equivalent wrapper commands are checked on the current operating system where possible. Do not claim cross-platform execution from a single operating system; verify wrapper file presence and document the Windows and Unix commands.
9. `git diff --check` passes, and version-control status contains no generated build output or temporary files.

Report commands, exit codes, and relevant test/package results. Never claim that tests passed, the JAR is runnable, or the build succeeded without executing the relevant command and confirming its result.

## Error handling

- Stop before editing when the package name or application entry point is missing or invalid.
- Stop and report conflicts when an existing user-authored `pom.xml`, source file, test, or wrapper file would be overwritten.
- Preserve compatible existing configuration and merge only necessary additions.
- If Java, Maven, the wrapper, dependency resolution, compilation, tests, packaging, manifest inspection, or JAR execution fails, report the exact command, affected path, and error output.
- Do not conceal failures with skipped tests, ignored errors, broad exception handling, or success-shaped fallback messages.
- Do not delete `target/` or user files to recover from an error. Temporary validation files may be removed only when their exact paths are known and they were created by this operation.
- If a required tool is unavailable, state which validation could not be performed and why.

## Idempotency

Running this skill repeatedly with the same inputs must not duplicate configuration or change unrelated work:

- Reuse an existing compatible `pom.xml` and add only missing configuration.
- Keep compiler release, dependency, Surefire, and JAR settings deterministic.
- Leave an identical `Calculator.java` and `BasicAdditionTest.java` unchanged.
- Preserve an existing Maven Wrapper and its selected Maven version unless an update is requested.
- Regenerate `target/` only through Maven; never track generated output.
- Use a uniquely named temporary directory for manifest inspection and remove only that directory after validation.
- Re-run all required validation commands after changes, even when the resulting configuration appears unchanged.

## Example usage

User request:

> Configure this Java 21 project with Maven and JUnit 5, add a calculator addition test, create a runnable `hello.jar`, and validate it.

Expected procedure:

1. Inspect the existing project and confirm the application entry point and package.
2. Configure `pom.xml` for Java 21, JUnit Jupiter, Surefire, and `target/hello.jar`.
3. Add `Calculator.java` and `BasicAdditionTest.java` without replacing unrelated files.
4. Create or preserve Maven Wrapper files when available.
5. Run:

   ```text
   mvn clean test
   mvn clean verify
   java -jar target/hello.jar
   ```

6. If the wrapper is available, also document:

   ```text
   Windows: .\mvnw.cmd clean test
   Windows: .\mvnw.cmd clean verify
   Unix: ./mvnw clean test
   Unix: ./mvnw clean verify
   ```

7. Inspect the JAR contents and manifest, then report verified results and any limitations.
