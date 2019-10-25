#!/bin/bash
set -e

cd "$(dirname $0)"

env-update
source /etc/profile

git clone "https://github.com/andrew-aladev/ocg.git" --single-branch --branch "master" --depth 1 "ocg"
cd "ocg"

./scripts/ci_test.sh
