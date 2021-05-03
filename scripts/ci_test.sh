#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

cd ".."

bash -cl "\
  gem install bundler --force && \
  bundle install && \
  bundle exec rake \
"
