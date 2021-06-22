setup_file() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  # get the containing directory of this file
  # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
  # as those will point to the bats executable's location or the preprocessed file respectively
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  # make executables in src/ visible to PATH
  PATH="$DIR/../src:$PATH"
}

@test "install_hooks (wrap existed cd/pushd/popd function)" {
  . builtin-hook.sh
  declare -i y2c_setup_has_been_called=0
  declare -i cd_func_has_been_called=0
  declare -i pushd_func_has_been_called=0
  declare -i popd_func_has_been_called=0

  local func_args=()

  y2c_setup() {
    y2c_setup_has_been_called=1
  }

  cd() {
    cd_func_has_been_called=1
    func_args=("$@")
  }

  pushd() {
    pushd_func_has_been_called=1
    func_args=("$@")
  }

  popd() {
    popd_func_has_been_called=1
  }

  install_hooks

  [ $Y2C_CD_FUNC_NAME ]
  [ $Y2C_PUSHD_FUNC_NAME ]
  [ $Y2C_POPD_FUNC_NAME ]

  y2c_setup_has_been_called=0
  cd_func_has_been_called=0
  func_args=()
  cd test
  [ $y2c_setup_has_been_called -eq 1 ]
  [ $cd_func_has_been_called -eq 1 ]
  [ "${func_args[*]}" = "test" ]

  y2c_setup_has_been_called=0
  pushd_func_has_been_called=0
  func_args=()
  pushd test
  [ $y2c_setup_has_been_called -eq 1 ]
  [ $pushd_func_has_been_called -eq 1 ]
  [ "${func_args[*]}" = "test" ]

  y2c_setup_has_been_called=0
  popd_func_has_been_called=0
  func_args=()
  popd
  [ $y2c_setup_has_been_called -eq 1 ]
  [ $popd_func_has_been_called -eq 1 ]
}

@test "install_hooks (call builtin cd/pushd/popd directly)" {
  . builtin-hook.sh
  declare -i y2c_setup_has_been_called=0
  local script_folder

  script_folder=$( dirname "$BATS_TEST_FILENAME" )

  y2c_setup() {
    y2c_setup_has_been_called=1
  }

  install_hooks

  [ ! $Y2C_CD_FUNC_NAME ]
  [ ! $Y2C_PUSHD_FUNC_NAME ]
  [ ! $Y2C_POPD_FUNC_NAME ]

  y2c_setup_has_been_called=0
  cd "${script_folder}/yarn-repo/test1"
  [ $y2c_setup_has_been_called -eq 1 ]
  [ "${PWD}" = "${script_folder}/yarn-repo/test1" ]

  y2c_setup_has_been_called=0
  pushd "../test2"
  [ $y2c_setup_has_been_called -eq 1 ]
  [ "${PWD}" = "${script_folder}/yarn-repo/test2" ]

  y2c_setup_has_been_called=0
  popd
  [ $y2c_setup_has_been_called -eq 1 ]
  [ "${PWD}" = "${script_folder}/yarn-repo/test1" ]
}
