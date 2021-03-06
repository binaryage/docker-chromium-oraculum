#!/usr/bin/env bash

set -e -o pipefail

cmd=$1
args=("$@")

PLATFORM=Linux_x64
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$ROOT/.cache"

DOCKER_RUN_OPTS=()
DOCKER_RUN_OPTS+=(-v "$CACHE_DIR:/oraculum/cache")
DOCKER_RUN_OPTS+=(-e "ORACULUM_VERBOSE=$ORACULUM_VERBOSE")
DOCKER_RUN_OPTS+=(-e "DEFAULT_PLATFORM=$PLATFORM")

do_usage() {
  echo -e "\nConsult the oraculum by sending exactly one command.\n"
  echo -e "Usage:\n"
  echo "oraculum.sh clean|build|prune-cache|hello|version|sh|latest-revision|download|download-link|describe"
  exit 1
}

if [[ "$cmd" == "clean" ]]; then
  rm -rf "$CACHE_DIR"
  docker rmi -f oraculum
  exit $?
fi

if [[ "$cmd" == "build" ]]; then
  docker build -t oraculum .
  exit $?
fi

if [[ "$cmd" == "prune-cache" ]]; then
  if [[ -d "$CACHE_DIR" ]]; then
    keep_count=${2:-3} # keep last 3 folders by default
    keep_no=$((keep_count + 1))
    # http://unix.stackexchange.com/a/18814/188074
    pushd "$CACHE_DIR" >/dev/null
    if [[ -d "$PLATFORM" ]]; then
      # shellcheck disable=SC2012
      ls -1td "$PLATFORM"/* | tail -n "+${keep_no}" | xargs rm -rf
    fi
    popd >/dev/null
  fi
  exit $?
fi

if [[ "$cmd" =~ ^(hello|version|sh|latest-revision|download|download-link|describe)$ ]]; then
  docker run "${DOCKER_RUN_OPTS[@]}" --rm oraculum "${args[@]}"
  exit $?
fi

if [[ -n "${args[*]}" ]]; then
  echo "unknown oraculum command"
fi

do_usage
