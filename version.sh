#!/bin/bash

set -e

if [[ -z "$GIT_LIST_TAGS_COMMAND" ]]; then
  GIT_LIST_TAGS_COMMAND=( "git" "ls-remote" "--tags" "--refs" "-q" "origin" )
else
  IFS=' ' read -r -a GIT_LIST_TAGS_COMMAND <<<"$GIT_LIST_TAGS_COMMAND"
fi

base_version() {
  date +%G.%-V
}

compute_version() {
  local prefix prerelease preprefix next inc rc

  prefix=$1
  prerelease=$2
  preprefix=$3

  next="${prefix}$(base_version)"
  inc=$("${GIT_LIST_TAGS_COMMAND[@]}" "${next}.*" | grep -v '\-.*[0-9]\+$' --count ||:)
  inc=$((inc+1))

  if [ "$prerelease" = true ]
  then
    next="${next}.${inc}"
    rc=$("${GIT_LIST_TAGS_COMMAND[@]}" "${next}-${preprefix}*" | wc -l)
    rc=$((rc+1))
    echo "${next}-${preprefix}${rc}"
  else
    echo "${next}.${inc}"
  fi
}

version="$(compute_version "$1" "$2" "$3")"

echo "::set-output name=version::$version"
