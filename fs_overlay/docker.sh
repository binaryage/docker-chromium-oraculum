#!/usr/bin/env bash

# this should be the docker entry point

cd /

source ./oraculum/lib/setup.sh
source ./oraculum/lib/functions.sh

cmd=$1

if [ "$cmd" = "hello" ]; then
  echo "hello from oraculum inside docker"
  exit $?
fi

if [ "$cmd" = "latest-revision" ]; then
  cd /oraculum
  exec ./latest-revision.sh ${@:2}
fi

if [ "$cmd" = "download-link" ]; then
  cd /oraculum
  exec ./download-link.sh ${@:2}
fi

if [ "$cmd" = "download" ]; then
  cd /oraculum
  exec ./download.sh ${@:2}
fi

if [ "$cmd" = "version" ]; then
  cd /oraculum
  exec ./version.sh ${@:2}
fi

if [ "$cmd" = "describe" ]; then
  cd /oraculum
  exec ./describe.sh ${@:2}
fi

if [ "$cmd" = "sh" ]; then
  exec "${@:2}"
fi

exec "$@"
