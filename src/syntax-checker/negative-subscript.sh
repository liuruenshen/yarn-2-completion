#!/usr/bin/env bash

main() {
  set -e
  local a=(100)
  # shellcheck disable=SC2034
  a[-1]=0
}

main
