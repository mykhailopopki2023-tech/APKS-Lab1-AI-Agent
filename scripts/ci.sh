#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"
bash "$PROJECT_ROOT/mvnw" --batch-mode clean verify

if [ ! -f "$PROJECT_ROOT/target/hello.jar" ]; then
    echo "ERROR: target/hello.jar was not generated." >&2
    exit 1
fi

java -jar "$PROJECT_ROOT/target/hello.jar"
