#!/usr/bin/env bash

log() {
  if [[ ! -z "$ORACULUM_VERBOSE" ]]; then
    (>&2 echo "$1")
  fi
}

error() {
  (>&2 echo "$1")
}

get_zip_name() {
  local platform=$1
  # note this is a linux container so Mac and Win platforms don't make much sense for most operations
  case ${platform} in
     Mac*) echo "chrome-mac.zip" ;;
     Win*) echo "chrome-win32.zip" ;;
     *) echo "chrome-linux.zip" ;;
  esac
}

print_var() {
  (cat <<__END__
${!1}
__END__
  )
}
