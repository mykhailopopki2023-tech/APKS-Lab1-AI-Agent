---
name: create-actions
description: "Create and validate cross-platform GitHub Actions CI using the github-actions skill."
argument-hint: "Optionally provide branch filters for push and pull-request validation."
agent: "agent"
---

# Create GitHub Actions

## Purpose

Create CI scripts and one GitHub Actions workflow that validates the Java 21 Maven project on Ubuntu, Windows, and macOS and uploads the generated `hello.jar`.

## Preconditions

- Read [.github/skills/github-actions/SKILL.md](../skills/github-actions/SKILL.md) before acting.
- Confirm the Maven Wrapper and `target/hello.jar` contract exist.
- Inspect existing workflows, scripts, wrapper files, and user changes.
- Do not modify application source, Maven configuration, or tests in this operation.

## Steps

1. Follow `github-actions/SKILL.md` as the authoritative procedure.
2. Create or safely update `scripts/ci.sh` for Linux/macOS.
3. Create or safely update `scripts/ci.bat` for Windows.
4. Create or safely update `.github/workflows/ci.yml`.
5. Configure push and pull-request triggers, one matrix build job, Temurin Java 21, Maven caching, and stable checkout/setup/upload action versions.
6. Ensure YAML invokes the scripts rather than duplicating Maven commands.
7. Ensure each script runs the Maven Wrapper with `clean verify`, checks `target/hello.jar`, and returns failures.
8. Validate the workflow and applicable local script.

## Expected output

- A three-OS matrix workflow exists.
- Linux/macOS and Windows scripts use their correct shell syntax.
- Each successful matrix run uploads a distinct `hello.jar` artifact.

## Validation

- Inspect workflow YAML for triggers, matrix, actions, Java 21, caching, script invocation, and artifact upload.
- Inspect both scripts for wrapper execution and JAR existence checks.
- Run the applicable local script and report platform limitations.
- Run `git diff --check`; confirm generated output is not tracked.

## Error handling

- Stop on workflow/script conflicts that would overwrite user behavior.
- Report YAML, wrapper, build, JAR, or local execution failures.
- Do not use ignored errors, `continue-on-error`, fake success, or secret-revealing logs.
- Do not claim all operating systems passed without corresponding runner evidence.

## Idempotency rules

- Keep one workflow, one build job, and one OS matrix.
- Preserve existing triggers and unrelated CI steps where compatible.
- Do not duplicate script commands or artifact uploads.
- Preserve wrapper and user files; add only missing configuration.
