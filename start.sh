#!/bin/bash

set -euo pipefail

: "${ORGANIZATION:?Environment variable ORGANIZATION not set}"
: "${ACCESS_TOKEN:?Environment variable ACCESS_TOKEN not set}"
: "${RUNNER_NAME:?Environment variable RUNNER_NAME not set}"

RUNNER_DIR="/home/runner/actions-runner"

cd "${RUNNER_DIR}"

echo "Removing existing runner (if registered)..."
./config.sh remove --unattended --token "${ACCESS_TOKEN}" || echo "No runner removed or already clean."

echo "Configuring fresh runner..."
./config.sh --url "https://github.com/${ORGANIZATION}" \
            --token "${ACCESS_TOKEN}" \
            --name "${RUNNER_NAME}" \
            --unattended \
            --replace

cleanup() {
    echo "Shutting down runner and cleaning up..."
    ./config.sh remove --unattended --token "${ACCESS_TOKEN}" || echo "Runner may have already been removed."
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

echo "Starting runner..."
./run.sh & wait $!