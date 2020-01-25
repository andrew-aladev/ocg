#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "./env.sh"

echo "-- running image $IMAGE_NAME --"
buildah run $(buildah from "$IMAGE_NAME") /home/entrypoint.sh
