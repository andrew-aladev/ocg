#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

TARGET="x86_64-alpine-linux-musl"
IMAGE_NAME="${DOCKER_HOST}/${DOCKER_USERNAME}/${IMAGE_PREFIX}_${TARGET}"
