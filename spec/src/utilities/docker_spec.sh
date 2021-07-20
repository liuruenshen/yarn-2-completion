#!/usr/bin/env bash

Describe "docker.sh" docker-utilities
  Include "./src/utilities/docker.sh"
  Include "./src/lib.sh"

  docker() {
    echo "$@"
  }

  It "build_docker should pass right arguments to the docker executable"
    When call build_docker "./Dockerfile" "pseudo-tag"
    The output should equal "build -t pseudo-tag -f ./Dockerfile ."
  End

  It "pull_docker should pass right arguments to the docker executable"
    When call pull_docker "pseudo-tag"
    The output should equal "pull pseudo-tag"
  End

  It "get_docker_image_id should pass right arguments to the docker executable"
    When call get_docker_image_id "pseudo-tag"
    The output should equal "images pseudo-tag -q"
  End

  It "get_docker_tag should return the correct docker image tag"
    When call get_docker_tag "./docker/bash-3-2.Dockerfile"
    The output should equal "kiwi93/bash-testing-coverage:bash-3-2"
    The status should equal 0
  End

  It "get_docker_tag should fail the passed dockerfile is not found"
    When call get_docker_tag "./docker/bash-1-0.Dockerfile"
    The output should equal ""
    The status should equal 1
  End

  It "docker_iterate should iterate all the files in the docker folder"
    echo_docker_iterate_arguments() {
      echo -n "${1##*docker/} "
      shift
      echo "$@"
    }

    get_docker_image_id() {
      y2c_get_var_name "$1"
    }

    When call docker_iterate "echo_docker_iterate_arguments" argu1 argu2
    The line 1 of output should equal "bash-3-2.Dockerfile kiwi93/bash-testing-coverage:bash-3-2 a2l3aTkzL2Jhc2gtdGVzdGluZy1jb3ZlcmFnZTpiYXNoLTMtMg__ argu1 argu2"
    The line 2 of output should equal "bash-4-4.Dockerfile kiwi93/bash-testing-coverage:bash-4-4 a2l3aTkzL2Jhc2gtdGVzdGluZy1jb3ZlcmFnZTpiYXNoLTQtNA__ argu1 argu2"
    The line 3 of output should equal "bash-5-0.Dockerfile kiwi93/bash-testing-coverage:bash-5-0 a2l3aTkzL2Jhc2gtdGVzdGluZy1jb3ZlcmFnZTpiYXNoLTUtMA__ argu1 argu2"
  End
End
