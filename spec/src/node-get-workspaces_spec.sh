#!/usr/bin/env bash

Describe "node src/get-workspaces.sh" get-workspaces
  It "should return empty string if insufficient argument is given"
    When run command node "./src/get-workspaces.js"
    The output should equal ''
    The status should equal 1
  End

  It "should return the error status indicating the module is unable to be found"
    When run command node "./src/get-workspaces.js" "/tmp/123/package.json"
    The output should equal ''
    The status should equal 4
  End

  It "should return the error status indicating the content is malformed"
    run_test() {
      mkdir -p "/tmp/pkg1"
      echo "12345" >"/tmp/pkg1/package.json"
      node "./src/get-workspaces.js" "/tmp/pkg1/package.json"
    }

    When call run_test
    The output should equal ''
    The status should equal 2
  End

  It "should return the workspaces in the workspaces field"
    run_test() {
      mkdir -p "/tmp/pkg2"
      echo '{"workspaces": ["packages/*"]}' >"/tmp/pkg2/package.json"
      node "./src/get-workspaces.js" "/tmp/pkg2/package.json"
    }

    When call run_test
    The output should equal 'packages/*'
    The status should equal 0
  End

  It "should return the workspaces in the workspaces.packages field"
    run_test() {
      mkdir -p "/tmp/pkg3"
      echo '{"workspaces": {"packages": ["packages/*"]}}' >"/tmp/pkg3/package.json"
      node "./src/get-workspaces.js" "/tmp/pkg3/package.json"
    }

    When call run_test
    The output should equal 'packages/*'
    The status should equal 0
  End

  It "should return empty string when the workspaces field is missing"
    run_test() {
      mkdir -p "/tmp/pkg4"
      echo '{"name": "test"}' >"/tmp/pkg4/package.json"
      node "./src/get-workspaces.js" "/tmp/pkg4/package.json"
    }

    When call run_test
    The output should equal ''
    The status should equal 3
  End

  It "should return empty string when the workspaces field's value is unexpected"
    run_test() {
      mkdir -p "/tmp/pkg5"
      echo '{"name": "test", "workspaces": "12345"}' >"/tmp/pkg5/package.json"
      node "./src/get-workspaces.js" "/tmp/pkg5/package.json"
    }

    When call run_test
    The output should equal ''
    The status should equal 3
  End
End
