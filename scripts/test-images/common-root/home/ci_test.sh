#!/usr/bin/env bash
set -e

env-update
source "/etc/profile"

DIR="/mnt/data"
RUBY_VERSIONS=(
  "ruby25"
  "ruby26"
  "ruby27"
  "ruby30"
)

if [ ! -d "$DIR" ]; then
  mkdir -p "$DIR"

  git clone "https://github.com/andrew-aladev/ocg.git" \
    --single-branch \
    --branch "master" \
    --depth 1 \
    "$DIR"
fi

cd "$DIR"

# "sudo" may be required.
if command -v "sudo" > /dev/null 2>&1; then
  sudo_prefix="sudo"
else
  sudo_prefix=""
fi

for RUBY_VERSION in "${RUBY_VERSIONS[@]}"; do
  $sudo_prefix eselect ruby set "$RUBY_VERSION"

  $sudo_prefix ./scripts/ci_test.sh
done
