#!/usr/bin/env bash

cd() {
  builtin cd "$@" && {
    y2c_setup
    return 0
  }
}

pushd() {
  builtin pushd "$@" && {
    y2c_setup
    return 0
  }
}

popd() {
  builtin popd "$@" && {
    y2c_setup
    return 0
  }
}
