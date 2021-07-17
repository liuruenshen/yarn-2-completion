#!/usr/bin/env bash

Describe "Integration Test" integration
  after_each_test() {
    rm -f "${PWD}/set-prompt-command-arr.rc"
  }

  AfterEach after_each_test

  Describe "invoke functions via PROMPT_COMMAND" prompt_command
    It "should define Y2C_SETUP_HAS_BEEN_CALLED when PROMPT_COMMAND is unset"
      run_test() {
        %preserve Y2C_SETUP_HAS_BEEN_CALLED:Y2C_SETUP_HAS_BEEN_CALLED_before
        env SHELL="$BASH" expect spec/integration/test-prompt-command.tcl "--norc" "${PWD}" ".+not found\r"
      }

      When call run_test
      The status should equal 0
      The variable Y2C_SETUP_HAS_BEEN_CALLED_before should be undefined
      The output should include "Y2C_SETUP_HAS_BEEN_CALLED=\"1\""
    End

    It "should define Y2C_SETUP_HAS_BEEN_CALLED when PROMPT_COMMAND is string"
      prompt_command_test1() {
        echo "prompt_command_test1 has been run by bash" >/tmp/prompt_command_test1
      }
      export -f prompt_command_test1
      export PROMPT_COMMAND="prompt_command_test1"

      run_test() {
        %preserve Y2C_SETUP_HAS_BEEN_CALLED:Y2C_SETUP_HAS_BEEN_CALLED_before
        env SHELL="$BASH" expect spec/integration/test-prompt-command.tcl "--norc" "${PWD}" ".+PROMPT_COMMAND=\"prompt_command_test1\"\r"
      }

      When call run_test
      The status should equal 0
      The variable Y2C_SETUP_HAS_BEEN_CALLED_before should be undefined
      The output should include "Y2C_SETUP_HAS_BEEN_CALLED=\"1\""
      The contents of file "/tmp/prompt_command_test1" should equal "prompt_command_test1 has been run by bash"
    End
  End

  Describe "in automated interactive shell testing environment"
    It "should function well"
      When run command env SHELL="$BASH" expect spec/integration/test-integration.tcl
      The output should include "yarn info --extra test"
      The status should equal 0
    End
  End
End
