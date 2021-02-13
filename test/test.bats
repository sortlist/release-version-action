#!/usr/bin/env bats

GIT_LIST_TAGS_COMMAND="git tag --list"
source "${BATS_TEST_DIRNAME}/../version.sh" >/dev/null 2>/dev/null

rand_prefix() {
  echo $(tr -dc a-z0-9 </dev/urandom | head -c 5)
}

setup() {
  prefix=$(rand_prefix)
  base_part="${prefix}$(base_version)"
}

teardown() {
  git tag --list "$prefix*" | xargs git tag -d
}

@test "Initial version" {
  run compute_version $prefix false

  [ $status -eq 0 ]
  [ "$output" = "${base_part}.1" ]
}

@test "Initial version with pre-release" {
  run compute_version $prefix true

  [ $status -eq 0 ]
  [ "$output" = "${base_part}.1-1" ]
}

@test "Initial version with pre-release and pre-release prefix" {
  prepre=$(rand_prefix)
  run compute_version $prefix true $prepre

  [ $status -eq 0 ]
  [ "$output" = "${base_part}.1-${prepre}1" ]
}

@test "Version increment" {
  git tag $(compute_version $prefix)

  run compute_version $prefix

  [ $status -eq 0 ]
  [ "$output" = "${base_part}.2" ]
}

@test "Version increment multi-digit" {
  for i in {1..100}
  do
    git tag "${base_part}.${i}"
  done

  run compute_version $prefix

  [ $status -eq 0 ]
  [ "$output" = "${base_part}.101" ]
}

@test "Version pre-release increment" {
  git tag $(compute_version $prefix true)

  run compute_version $prefix true

  [ $status -eq 0 ]
  [ "$output" = "${base_part}.1-2" ]
}

@test "Version pre-release increment multi-digit" {
  for i in {1..100}
  do
    git tag "${base_part}.1-${i}"
  done

  run compute_version $prefix true

  [ $status -eq 0 ]
  [ "$output" = "${base_part}.1-101" ]
}

@test "Version pre-release increment existing version" {
  git tag $(compute_version $prefix)

  run compute_version $prefix true

  [ $status -eq 0 ]
  [ "$output" = "${base_part}.2-1" ]
}
