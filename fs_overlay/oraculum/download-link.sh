#!/usr/bin/env bash

source ./lib/setup.sh
source ./lib/functions.sh

REVISION=${1:-$(./latest-revision.sh)}
PLATFORM=${2:-$DEFAULT_PLATFORM}
ZIP_NAME=$(get_zip_name "${PLATFORM}")
ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/$PLATFORM%2F$REVISION%2F$ZIP_NAME?alt=media"

echo "${ZIP_URL}"
