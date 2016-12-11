#!/usr/bin/env bash

source ./lib/setup.sh
source ./lib/functions.sh

PLATFORM=${1:-$DEFAULT_PLATFORM}
URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/$PLATFORM%2FLAST_CHANGE?alt=media"

log "fetching revision number for latest known snapshot from $URL"

REVISION=$(curl -s -S ${URL})

if [[ ! "${REVISION}" =~ ^[0-9]+$ ]]; then
  log "error fetching revision number, got:"
  error "${REVISION}" # hopefully REVISION contains some error report thanks to curl's -S flag
  exit 1
fi

echo "${REVISION}"
