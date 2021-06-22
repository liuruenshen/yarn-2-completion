setup_file() {
  load "test_helper/common_setup"
  _common_setup
}

setup() {
  cd "$( dirname "$BATS_TEST_FILENAME" )/yarn-repo"
}

@test "integration test" {
  . lib.sh

  y2c_yarn_completion_main

  complete | grep -q y2c_yarn_completion_for_complete

  cd test1
  COMP_WORDS=("yarn" "add" "--json" "--")
  y2c_yarn_completion_for_complete "yarn" "--" "--json"
  [ "${COMPREPLY[*]}" == "--exact --tilde --caret --dev --peer --optional --prefer-dev --interactive --cached" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "")
  y2c_yarn_completion_for_complete "yarn" "" "sources"
  [ "${COMPREPLY[*]}" == "--path #0 --repository #0 --branch #0 --no-minify -f --force name" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--path" "")
  y2c_yarn_completion_for_complete "yarn" "" "--path"
  [ "${COMPREPLY[*]}" == "#0" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--path" "/test" "--force" "")
  y2c_yarn_completion_for_complete "yarn" "" "--force"
  [ "${COMPREPLY[*]}" == "--repository #0 --branch #0 --no-minify name" ]

  COMP_WORDS=("yarn" "w")
  y2c_yarn_completion_for_complete "yarn" "w" "yarn"
  [ "${COMPREPLY[*]}" == "why workspace workspaces" ]

  COMP_WORDS=("yarn" "workspace" "")
  y2c_yarn_completion_for_complete "yarn" "" "workspace"
  [ "${COMPREPLY[*]}" == "wrk-a wrk-b wrk-c" ]

  COMP_WORDS=("yarn" "workspace" "wrk-a" "w")
  y2c_yarn_completion_for_complete "yarn" "w" "wrk-a"
  [ "${COMPREPLY[*]}" == "why" ]

  COMP_WORDS=("yarn" "run" "")
  y2c_yarn_completion_for_complete "yarn" "" "run"
  [ "${COMPREPLY[*]}" == "--inspect --inspect-brk dev test" ]

  #COMP_WORDS=("yarn" "workspace" "wrk-a" "")
  #y2c_yarn_completion_for_complete "yarn" "" "wrk-a"
  #echo "${COMPREPLY[*]}"
  #[ "${COMPREPLY[*]}" == "build setup test deploy" ]
}
