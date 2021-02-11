#!/bin/sh

set -e

function compute_version() {
  git fetch --tags

  local prefix=$1
  local prerelease=$2
  local preprefix=$3

  local next="${prefix}$(date +%G.%-V)"
  local inc=$(git tag --list "${next}.?" | wc -l)
  inc=$(($inc+1))

  if [ "$prerelease" = true ]
  then
    next="${next}.${inc}"
    rc=$(($(git tag --list "${next}-${preprefix}?" | wc -l)+1))
    echo "${next}-${preprefix}${rc}"
  else
    echo "${next}.${inc}"
  fi
}

version="$(compute_version $1 $2 $3)"

echo "::set-output name=version::$version"
