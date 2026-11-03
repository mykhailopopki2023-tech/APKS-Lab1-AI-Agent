---
name: github-actions
description: "Use when creating or validating GitHub Actions CI for a Java 21 Maven project. Configures cross-platform push and pull-request builds on Ubuntu, Windows, and macOS, invokes platform scripts, and uploads the generated hello.jar."
---

# GitHub Actions

## Purpose

Provide a repeatable procedure for creating cross-platform GitHub Actions CI for a Java 21 Apache Maven project. The workflow must build and verify the project on Ubuntu, Windows, and macOS, use the Maven Wrapper through platform-specific scripts, confirm that `target/hello.jar` exists, and upload that JAR as an artifact for each operating system.

This skill describes a future CI configuration operation. It does not itself create `.github/workflows/ci.yml` or script files unless an agent invokes it for a user request.

## When to use

Use this skill when a user asks to:

- Add or repair GitHub Actions CI for a Java Maven project.
- Test a Java 21 project on Linux, Windows, and macOS.
- Configure Java setup and Maven dependency caching in GitHub Actions.
- Run Maven Wrapper verification through repository scripts.
- Upload the generated `hello.jar` from CI.

Do not use it to change application code, Maven dependencies, tests, or release publishing unless the user separately requests those changes.

## Inputs

Before editing, obtain or confirm:

1. **Project root**: The repository containing the Maven Wrapper and project files.
2. **Maven Wrapper**: `mvnw`, `mvnw.cmd`, and the `.mvn/wrapper/` files must exist or be created by the build configuration task.
3. **JAR path**: The expected executable JAR, normally `target/hello.jar`.
4. **CI branch policy**: The branches that should receive push and pull-request validation. If not specified, use all branches with `push:` and `pull_request:` triggers.

Inspect existing workflows, scripts, wrapper files, `pom.xml`, ignore rules, and user changes before modifying anything. Do not overwrite an existing workflow or script without comparing and safely merging it.

## Outputs

When invoked successfully, produce or safely update:

- `.github/workflows/ci.yml`.
- `scripts/ci.sh` for Linux and macOS.
- `scripts/ci.bat` for Windows.
- A single `build` job with an operating-system matrix containing:
  - `ubuntu-latest`
  - `windows-latest`
  - `macos-latest`
- Java 21 configured through Eclipse Temurin.
- Maven dependency caching through `actions/setup-java`.
- A per-OS artifact containing `target/hello.jar`.

The workflow must use `actions/checkout@v4`, `actions/setup-java@v4`, and `actions/upload-artifact@v4`. These are supported stable major versions and must not be replaced with invented action versions. Do not add a separate Maven build command to YAML when the scripts already execute it.

## Execution procedure

1. Inspect the repository and record its current version-control state. Confirm the wrapper, expected JAR path, and existing CI conventions.
2. Create `.github/workflows/ci.yml` with:
   - `name` describing the CI workflow.
   - `on.push` and `on.pull_request` triggers.
   - One `build` job.
   - `strategy.matrix.os` containing exactly `ubuntu-latest`, `windows-latest`, and `macos-latest`.
   - `runs-on: ${{ matrix.os }}`.
3. Add a checkout step using `actions/checkout@v4`.
4. Add a Java setup step using `actions/setup-java@v4` with:
   - `distribution: temurin`.
   - `java-version: '21'`.
   - `cache: maven` for Maven dependency caching.
5. Add script execution steps without duplicating Maven lifecycle commands in YAML:
   - On Ubuntu and macOS, run `bash ./scripts/ci.sh`.
   - On Windows, run `.\scripts\ci.bat` using a Windows command shell.
   - Use `if: runner.os != 'Windows'` and `if: runner.os == 'Windows'` or equivalent explicit conditions.
6. Create `scripts/ci.sh`:
   - Use a POSIX-compatible shell, such as `#!/usr/bin/env bash`.
   - Enable fail-fast behavior, such as `set -e`.
   - Resolve execution from the repository root or ensure the workflow invokes it from the root.
   - Execute the Maven Wrapper with `./mvnw clean verify`.
   - Check that `target/hello.jar` exists and fail with a clear error if it does not.
   - Do not silently continue after a failed build or missing JAR.
7. Create `scripts/ci.bat`:
   - Use Windows batch syntax.
   - Execute `mvnw.cmd clean verify`.
   - Check `target\hello.jar` exists with `if not exist`.
   - Return a non-zero error level when Maven or the JAR check fails.
   - Keep commands compatible with the standard Windows runner command shell.
8. Ensure `scripts/ci.sh` has executable permissions in version control where supported. The workflow may invoke it explicitly through `bash`, so Windows does not need to interpret the POSIX script.
9. Add an upload step using `actions/upload-artifact@v4`:
   - Upload `target/hello.jar`.
   - Give each matrix run a distinct artifact name, such as `hello-jar-${{ matrix.os }}`.
   - Configure the step to run only after the script succeeds.
10. Review the workflow to confirm it has one build job, one OS matrix, the required actions, and no direct `mvn` or `mvnw` lifecycle command outside the scripts.
11. Review the complete diff and status. Do not include generated `target/` output, secrets, credentials, or unrelated files.

### Shell differences

Linux and macOS runners use a Unix-like shell. `ci.sh` uses POSIX/Bash syntax, forward-slash paths, `./mvnw`, and Unix exit status behavior. It must be invoked with `bash` or have executable permissions.

Windows runners use `cmd.exe` batch syntax. `ci.bat` uses `mvnw.cmd`, backslash paths, `if not exist`, and `%ERRORLEVEL%`/`exit /b` semantics. Do not use Bash variables, `set -e`, Unix path assumptions, or `./mvnw` in the batch script. Keep the two scripts functionally equivalent even though their syntax differs.

## Validation

Validate the CI configuration without claiming that remote CI passed unless it was actually run:

1. Confirm `.github/workflows/ci.yml`, `scripts/ci.sh`, and `scripts/ci.bat` exist.
2. Parse or lint the workflow YAML with an available validator, and inspect it for:
   - Both `push` and `pull_request`.
   - Exactly one build job.
   - All three required matrix operating systems.
   - `actions/checkout@v4`, `actions/setup-java@v4`, and `actions/upload-artifact@v4`.
   - Temurin Java 21 and `cache: maven`.
   - Script invocation rather than duplicated Maven commands.
3. Inspect both scripts and confirm each invokes the Maven Wrapper with `clean verify`.
4. Confirm each script checks for `target/hello.jar` and returns failure when it is missing.
5. If the local operating system permits, run the applicable script and confirm:
   - The Maven Wrapper exits successfully.
   - `target/hello.jar` is generated.
   - The script exits with status zero.
6. Confirm the workflow uploads `target/hello.jar` only after successful script execution and uses distinct names per matrix OS.
7. Run `git diff --check` and inspect version-control status for generated artifacts or temporary files.

The Windows script cannot be executed as a Windows batch process from a Unix shell, and the Unix script cannot validate Windows command semantics. Report platform limitations explicitly. Never claim that all three runners passed based only on local execution.

## Error handling

- Stop before editing when the Maven Wrapper or expected JAR contract is missing and cannot be established safely.
- Stop and report conflicts when an existing workflow or script contains user-authored behavior that would be overwritten.
- Preserve compatible workflow triggers, permissions, and script logic; merge only necessary changes.
- If YAML parsing, action setup, dependency resolution, wrapper execution, JAR generation, artifact preparation, or local script execution fails, report the exact operation and error.
- Do not hide failures with `continue-on-error`, unconditional success commands, ignored exit codes, or artifact uploads of nonexistent files.
- Do not expose repository secrets or print credentials in workflow logs.
- Do not delete user files or generated files to recover from an error. Remove only temporary files created by this operation when their exact paths are known.
- If a validator or runner is unavailable, state which validation could not be performed and why.

## Idempotency

Running this skill repeatedly with the same inputs must not duplicate jobs, triggers, script commands, or artifact uploads:

- Reuse an existing compatible workflow and scripts.
- Preserve existing branch filters, permissions, and unrelated CI steps unless the requested behavior requires a change.
- Keep one build job and one OS matrix rather than appending another workflow implementation.
- Keep action major versions explicit and stable.
- Add each required script command and JAR check only once.
- Do not commit `target/`, caches, logs, or downloaded artifacts.
- Re-run static validation and applicable local checks after determining that no changes are necessary.

## Example usage

User request:

> Add cross-platform GitHub Actions CI for this Java 21 Maven project and upload `hello.jar`.

Expected workflow behavior:

1. Trigger on pushes and pull requests.
2. Run one `build` job across `ubuntu-latest`, `windows-latest`, and `macos-latest`.
3. Check out the repository and install Temurin Java 21 with Maven caching.
4. Run `bash ./scripts/ci.sh` on Ubuntu/macOS and `.\scripts\ci.bat` on Windows.
5. Have each script execute its platform’s Maven Wrapper with `clean verify` and verify `target/hello.jar`.
6. Upload `target/hello.jar` as `hello-jar-${{ matrix.os }}` using `actions/upload-artifact@v4`.
7. Validate the YAML, scripts, artifact path, and local platform behavior, reporting remote-run limitations honestly.
