#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./aarch64_be-unknown-linux-gnu/run.sh
./aarch64-unknown-linux-gnu/run.sh
