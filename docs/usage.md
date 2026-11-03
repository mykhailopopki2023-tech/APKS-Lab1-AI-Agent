# APKS Laboratory 1 Usage

## Required Software

Install the following software:

- Java Development Kit (JDK) 21.
- Apache Maven, unless the Maven Wrapper is already available.
- Git.
- Visual Studio Code with GitHub Copilot Chat.
- A GitHub account and repository access if GitHub Actions or remote collaboration is required.

For CI, GitHub Actions supplies Java 21 through Eclipse Temurin on Ubuntu, Windows, and macOS runners.

## Open and Select `build-engineer`

1. Open the repository folder in Visual Studio Code.
2. Open GitHub Copilot Chat.
3. Select the agent picker.
4. Choose `build-engineer`.

The agent is defined in [build-engineer.agent.md](../.github/agents/build-engineer.agent.md). It can read, search, edit, and execute commands required for build automation.

## Execute Prompt Commands

Prompt files appear as reusable slash commands in GitHub Copilot Chat. Type `/` and select the required prompt, or use **Chat: Run Prompt...**.

### `/git-init`

Inspects the Git repository, current branch, status, remotes, and `.gitignore`. It may safely create or update `.gitignore`, but it never commits or pushes automatically.

### `/create-project`

Provide a project name and Java package name. The prompt reads [project-scaffold](../.github/skills/project-scaffold/SKILL.md), creates the standard source directories and Hello World application, and validates the source structure.

Example:

```text
/create-project
Project name: hello-java
Package name: com.example.hello
```

### `/create-build`

Reads [build-and-test](../.github/skills/build-and-test/SKILL.md), creates or updates Maven and JUnit 5 configuration, adds the calculator addition test, configures the executable JAR, and validates the build.

### `/create-actions`

Reads [github-actions](../.github/skills/github-actions/SKILL.md), creates the Linux/macOS and Windows CI scripts and the cross-platform workflow, then validates the configuration.

### `/check`

Performs read-only checks of the agent, skills, prompts, Java/Maven configuration, CI workflow, Git status, and ignored build files. It runs `mvn clean verify` but does not modify project source or configuration.

## Run Complete Initialization

Use `/init` to run the five operations in order:

```text
/git-init
/create-project
/create-build
/create-actions
/check
```

The `/init` prompt coordinates this sequence automatically and stops immediately if a stage fails. Provide the project name and Java package before starting. It produces a detailed report with commands, changed files, validation evidence, and any failure point.

## Build and Test the Java Project

From the repository root, run:

```text
mvn clean test
mvn clean verify
```

If the Maven Wrapper is available, use the platform-specific commands:

```text
# Windows
.\mvnw.cmd clean test
.\mvnw.cmd clean verify

# Linux or macOS
./mvnw clean test
./mvnw clean verify
```

`clean test` removes previous build output, compiles the project, and runs JUnit 5 tests. `clean verify` runs the full Maven verification lifecycle and packages the application.

## Run the Generated JAR

After a successful package or verify operation, confirm that `target/hello.jar` exists and run:

```text
java -jar target/hello.jar
```

The command should exit successfully and print the application output. The JAR must contain a manifest with the correct `Main-Class` attribute.

## Validation and Safety

Inspect results rather than assuming success. Confirm test counts, Maven exit codes, JAR existence, manifest contents, and Git status. Do not commit `target/`, secrets, credentials, or temporary validation files. The agent and prompts preserve existing user files and report conflicts instead of silently overwriting them.
