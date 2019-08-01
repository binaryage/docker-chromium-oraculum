#!/usr/bin/env bash

source ./lib/setup.sh
source ./lib/functions.sh

REVISION=${1:-$(./latest-revision.sh)}
KEY=$2

# fetch JSON information about given revision
URL="https://cr-rev.appspot.com/_ah/api/crrev/v1/redirect/$REVISION"
RESULT=$(curl -s -S "${URL}")

# shellcheck disable=SC2181
if [[ $? -ne 0 ]]; then
  log "failed to fetch from $URL"
  error "${RESULT}" # RESULT should contain some error description thanks to curl's -S flag
  exit 1
fi

# if no key provided, we simply return whole JSON as is
if [[ -z "$KEY" ]]; then
  echo "${RESULT}"
  exit 0
fi

set +e
VALUE=$(print_var RESULT | jq -e ".$KEY" 2>&1)
STATUS=$?
set -e

if [[ ${STATUS} -ne 0 ]]; then
  error "failed to retrieve '$KEY' from: $URL"
  error "$RESULT"
  error "$VALUE"
  exit 33
fi

print_var VALUE
