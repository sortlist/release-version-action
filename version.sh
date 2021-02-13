#!/bin/bash

set -e

function base_version() {
  echo $(date +%G.%-V)
}

function compute_version() {
  local prefix=$1
  local prerelease=$2
  local preprefix=$3

  local next="${prefix}$(base_version)"

  git fetch origin "refs/tags/$next*:refs/tags/$next*"

  local inc=$(git tag --list "${next}.*" | grep -v '\-.*[0-9]\+$' --count)
  inc=$(($inc+1))

  if [ "$prerelease" = true ]
  then
    next="${next}.${inc}"
    rc=$(($(git tag --list "${next}-${preprefix}*" | wc -l)+1))
    echo "${next}-${preprefix}${rc}"
  else
    echo "${next}.${inc}"
  fi
}

version="$(compute_version $1 $2 $3)"

echo "::set-output name=version::$version"
