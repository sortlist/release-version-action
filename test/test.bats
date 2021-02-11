#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/../version.sh" >/dev/null 2>/dev/null

rand_prefix() {
  echo $(tr -dc A-Za-z0-9 </dev/urandom | head -c 5)
}

@test "Initial version" {
  prefix=$(rand_prefix)

  run compute_version $prefix false
  [ $status -eq 0 ]
  [ "$output" = "${prefix}$(date +%G.%-V).1" ]
}

@test "Initial version with pre-release" {
  prefix=$(rand_prefix)

  run compute_version $prefix true
  [ $status -eq 0 ]
  [ "$output" = "${prefix}$(date +%G.%-V).1-1" ]
}

@test "Initial version with pre-release and pre-release prefix" {
  prefix=$(rand_prefix)

  run compute_version $prefix true rc
  [ $status -eq 0 ]
  [ "$output" = "${prefix}$(date +%G.%-V).1-rc1" ]
}

@test "Version increment" {
  prefix=$(rand_prefix)
  v=$(compute_version $prefix)
  git tag $v

  run compute_version $prefix
  git tag -d $v
  [ $status -eq 0 ]
  [ "$output" = "${prefix}$(date +%G.%-V).2" ]
}

@test "Version pre-release increment" {
  prefix=$(rand_prefix)
  v=$(compute_version $prefix true)
  git tag $v

  run compute_version $prefix true
  git tag -d $v
  [ $status -eq 0 ]
  [ "$output" = "${prefix}$(date +%G.%-V).1-2" ]
}

@test "Version pre-release increment existing version" {
  prefix=$(rand_prefix)
  v=$(compute_version $prefix)
  git tag $v

  run compute_version $prefix true
  git tag -d $v
  [ $status -eq 0 ]
  [ "$output" = "${prefix}$(date +%G.%-V).2-1" ]
}
