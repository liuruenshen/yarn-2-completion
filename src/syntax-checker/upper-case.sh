#!/usr/bin/env bash

main() {
  set -e
  local a="abc"
  echo "${a^^}"
}

main
