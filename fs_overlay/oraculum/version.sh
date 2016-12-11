#!/usr/bin/env bash

source ./lib/setup.sh
source ./lib/functions.sh

REVISION=${1:-$(./latest-revision.sh)}
PLATFORM=${2:-$DEFAULT_PLATFORM}

DOWNLOAD_DIR=$(./download.sh ${REVISION} ${PLATFORM})

cd ${DOWNLOAD_DIR}

./chrome --version
