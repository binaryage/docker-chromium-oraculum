#!/usr/bin/env bash

source ./lib/setup.sh
source ./lib/functions.sh

REVISION=${1:-$(./latest-revision.sh)}
PLATFORM=${2:-$DEFAULT_PLATFORM}

CACHE_DIR="/oraculum/cache/$PLATFORM"
CACHE_LOCATION="$CACHE_DIR/$REVISION"

if [[ -d "$CACHE_LOCATION" ]]; then
  log "already cached in $CACHE_LOCATION"
  echo "$CACHE_LOCATION"
  exit 0
fi

ZIP_URL=$(./download-link.sh ${REVISION} ${PLATFORM})
ZIP_FILE="snapshot.zip"

log "downloading $ZIP_URL"

mkdir -p "$CACHE_LOCATION"

finish() {
  if [[ $? -ne 0 ]]; then
    # on failure we don't want to leave incomplete cache behind
    rm -rf "$CACHE_LOCATION"
  fi
}
trap finish EXIT

cd "$CACHE_LOCATION"
curl -s "$ZIP_URL" > "$ZIP_FILE"

if [[ ! -f "$ZIP_FILE" ]]; then
  echo "failed to download Chromium snapshot from $ZIP_URL"
  exit 31
fi

if grep -q "Not Found" "$ZIP_FILE"; then
  error "Chromium snapshot $PLATFORM/$REVISION not found at $ZIP_URL"
  exit 30
fi

log "unzipping $CACHE_LOCATION/$ZIP_FILE"
unzip -qq "$ZIP_FILE"
rm "$ZIP_FILE"

# mv chrome-linux/* .
BASE_DIR="$(ls -1)"
mv "${BASE_DIR}"/* .
rm -rf "${BASE_DIR}"

log "cached in $CACHE_LOCATION"

echo "$CACHE_LOCATION"
