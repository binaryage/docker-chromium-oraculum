#!/usr/bin/env bash

set -e

cmd=$1
args=$@

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOCKER_RUN_OPTS="\
-v $ROOT/.cache:/oraculum/cache \
-e ORACULUM_VERBOSE=$ORACULUM_VERBOSE \
-e DEFAULT_PLATFORM=Linux_x64"

if [[ "$cmd" = "clean" ]]; then
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
