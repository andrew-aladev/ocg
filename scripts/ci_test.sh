#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd ".."
ROOT_DIR=$(pwd)

whoami

/usr/bin/env bash -cl "\
  whoami && \
  cd \"$ROOT_DIR\" && \
  gem install bundler --force && \
  bundle install && \
  bundle exec rake \
"
