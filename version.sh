#!/bin/sh

set -e

GIT_LIST_TAGS_COMMAND=${GIT_LIST_TAGS_COMMAND:-"git ls-remote --tags --refs -q origin"}

function base_version() {
  echo $(date +%G.%-V)
}

function compute_version() {
  local prefix=$1
  local prerelease=$2
  local preprefix=$3

  local next="${prefix}$(base_version)"
  local inc=$($GIT_LIST_TAGS_COMMAND "${next}.*" | grep -v '\-.*[0-9]\+$' --count ||:)
  inc=$(($inc+1))

  if [ "$prerelease" = true ]
  then
    next="${next}.${inc}"
    rc=$($GIT_LIST_TAGS_COMMAND "${next}-${preprefix}*" | wc -l)
    rc=$(($rc+1))
    echo "${next}-${preprefix}${rc}"
  else
    echo "${next}.${inc}"
  fi
}

version="$(compute_version $1 $2 $3)"

echo "::set-output name=version::$version"
