#!/usr/bin/env bash

set -e -o pipefail

cmd=$1
args=$@

PLATFORM=Linux_x64
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$ROOT/.cache"

DOCKER_RUN_OPTS="\
-v $CACHE_DIR:/oraculum/cache \
-e ORACULUM_VERBOSE=$ORACULUM_VERBOSE \
-e DEFAULT_PLATFORM=$PLATFORM"

if [[ "$cmd" = "clean" ]]; then
  rm -rf "$CACHE_DIR"
  docker rm oraculum
  exit $?
fi

if [[ "$cmd" = "build" ]]; then
  docker build -t oraculum .
  exit $?
fi

if [[ "$cmd" =~ ^(hello|version|sh|latest-revision|download|download-link|describe)$ ]]; then
  docker run ${DOCKER_RUN_OPTS} oraculum ${args}
  exit $?
fi

echo "unknown oraculum command"
