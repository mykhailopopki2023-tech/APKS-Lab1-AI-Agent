---
name: check
description: "Perform read-only repository, configuration, build, and CI checks for the Java 21 Maven project."
argument-hint: "Optionally provide extra read-only checks to perform."
agent: "agent"
---

# Check Project

## Purpose

Perform a read-only health check of the repository's agent configuration, Java/Maven project, tests, CI workflow, Git state, and ignored build files.

## Preconditions

- Do not modify project source, Maven configuration, workflows, scripts, prompts, skills, or other configuration files.
- Inspect the repository root and current Git status first.
- Confirm Java and Maven commands are available before running them.

## Steps

1. Check the build-engineer agent manifest.
2. Check all three skills: `project-scaffold`, `build-and-test`, and `github-actions`.
3. Check all six prompt files and their frontmatter.
4. Check Java source layout, package declarations, `pom.xml`, JUnit configuration, wrapper files, and executable-JAR configuration.
5. Run `mvn clean verify` and capture the actual result.
6. Validate workflow YAML, triggers, matrix operating systems, actions, scripts, and artifact path.
7. Check `git status` and confirm build output is ignored and not tracked.

## Expected output

Produce a check report with pass, fail, or not-run status for every check, including command output summaries, test counts, JAR evidence, CI findings, and Git status.

## Validation

- Verify every requested file exists and has valid frontmatter where applicable.
- Confirm Java release 21, JUnit 5, Maven Wrapper, and `hello.jar` configuration.
- Confirm `mvn clean verify` actually completed successfully before reporting a pass.
- Confirm the CI workflow is structurally valid and cross-platform.
- Confirm no tracked build artifacts or secrets are present.

## Error handling

- Stop or mark the affected check failed when a command fails.
- Report unavailable tools and skipped checks as not-run.
- Never modify files to repair a finding.
- Never claim overall success when any required check failed or was not verified.

## Idempotency rules

- Perform only reads, validation, and build commands that generate ordinary ignored output.
- Do not rewrite generated files, normalize formatting, or alter Git state.
- Repeated checks must not change tracked or user-authored files.
