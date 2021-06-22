setup_file() {
  load "test_helper/common_setup"
  _common_setup
}

# The native "yarn --version" command is a bit slow, so this function is a workaround
# to get the yarn version faster for accelerating the testing.
yarn_get_version_from_yarnrc() {
  local yarn_version=""
  local inspected_path="${PWD}"

  while [[ -n "${inspected_path}" ]]; do
    if [[ -f "${inspected_path}/.yarnrc.yml" ]]; then
      yarn_version=$(cat "${inspected_path}/.yarnrc.yml" | grep yarnPath)
      yarn_version=${yarn_version#*yarn-}
      yarn_version=${yarn_version%.*}

      echo "$yarn_version"
      return $?
    fi
    inspected_path="${inspected_path%/*}"
  done

  echo "1.22.10"
  return
}

# Before yarn_help_mock gets called, making sure that y2c_is_yarn_2 function has been called.
# It is the function that helps speed up testing
yarn_help_mock() {
    case "${Y2C_YARN_VERSION}" in
        2.4.2)
        cat <<"END"
Yarn Package Manager - 2.4.2

  $ yarn <command>

Where <command> is one of:

  yarn add [--json] [-E,--exact] [-T,--tilde] [-C,--caret] [-D,--dev] [-P,--peer] [-O,--optional] [--prefer-dev] [-i,--interactive] [--cached] ...
    add dependencies to the project

  yarn bin [-v,--verbose] [--json] [name]
    get the path to a binary script

  yarn cache clean [--mirror] [--all]
    remove the shared cache files

  yarn config [-v,--verbose] [--why] [--json]
    display the current configuration

  yarn config get [--json] [--no-redacted] <name>
    read a configuration settings

  yarn config set [--json] [-H,--home] <name> <value>
    change a configuration settings

  yarn dedupe [-s,--strategy #0] [-c,--check] [--json] ...
    deduplicate dependencies with overlapping ranges

  yarn dlx [-p,--package #0] [-q,--quiet] <command> ...
    run a package in a temporary environment

  yarn exec <commandName> ...
    execute a shell command

  yarn explain peer-requirements [hash]
    explain a set of peer requirements

  yarn info [-A,--all] [-R,--recursive] [-X,--extra #0] [--cache] [--dependents] [--manifest] [--name-only] [--virtuals] [--json] ...
    see information related to packages

  yarn init [-p,--private] [-w,--workspace] [-i,--install]
    create a new package

  yarn install [--json] [--immutable] [--immutable-cache] [--check-cache] [--inline-builds] [--skip-builds]
    install the project dependencies

  yarn link [-A,--all] [-p,--private] [-r,--relative] <destination>
    connect the local project to another one

  yarn node ...
    run node with the hook already setup

  yarn npm audit [-A,--all] [-R,--recursive] [--environment #0] [--json] [--severity #0]
    perform a vulnerability audit against the installed packages

  yarn pack [--install-if-needed] [-n,--dry-run] [--json] [-o,--out #0] [--filename #0]
    generate a tarball from the active workspace

  yarn patch <package>
    This command will cause a package to be extracted in a temporary directory (under a folder named "patch-workdir"). This folder will be editable at will; running `yarn patch` inside it will then cause Yarn to generate a patchfile and register it into your top-level manifest (cf the `patch:` protocol).

  yarn patch-commit <patchFolder>
    This will turn the folder passed in parameter into a patchfile suitable for consumption with the `patch:` protocol.
Only folders generated through `yarn patch` are accepted as valid input for `yarn patch-commit`.

  yarn rebuild ...
    rebuild the project's native packages

  yarn remove [-A,--all] ...
    remove dependencies from the project

  yarn run [--inspect] [--inspect-brk] <scriptName> ...
    run a script defined in the package.json

  yarn set resolution [-s,--save] <descriptor> <resolution>
    enforce a package resolution

  yarn set version [--only-if-needed] <version>
    lock the Yarn version used by the project

  yarn set version from sources [--path #0] [--repository #0] [--branch #0] [--plugin #0] [--no-minify] [-f,--force]
    build Yarn from master

  yarn unplug [-A,--all] [-R,--recursive] [--json] ...
    force the unpacking of a list of packages

  yarn up [-i,--interactive] [-E,--exact] [-T,--tilde] [-C,--caret] ...
    upgrade dependencies across the project

  yarn why [-R,--recursive] [--json] [--peers] <package>
    display the reason why a package is needed

Npm-related commands:

  yarn npm info [-f,--fields #0] [--json] ...
    show information about a package

  yarn npm login [-s,--scope #0] [--publish]
    store new login info to access the npm registry

  yarn npm logout [-s,--scope #0] [--publish] [-A,--all]
    logout of the npm registry

  yarn npm publish [--access #0] [--tag #0] [--tolerate-republish]
    publish the active workspace to the npm registry

  yarn npm tag add <package> <tag>
    add a tag for a specific version of a package

  yarn npm tag list [--json] [package]
    list all dist-tags of a package

  yarn npm tag remove <package> <tag>
    remove a tag from a package

  yarn npm whoami [-s,--scope #0] [--publish]
    display the name of the authenticated user

Plugin-related commands:

  yarn plugin import <name>
    download a plugin

  yarn plugin import from sources [--path #0] [--repository #0] [--branch #0] [--no-minify] [-f,--force] <name>
    build a plugin from sources

  yarn plugin list [--json]
    list the available official plugins

  yarn plugin remove <name>
    remove a plugin

  yarn plugin runtime [--json]
    list the active plugins

Workspace-related commands:

  yarn workspace <workspaceName> <commandName> ...
    run a command within the specified workspace

  yarn workspaces foreach [-A,--all] [-j,--jobs #0] <commandName> ...
    YYarn 2.4.1 has this command but not in 2.4.2. Adding the command in the test
    ensures the script works well when there are two or even more commands with command-name variables being expanded.

  yarn workspaces list [-v,--verbose] [--json]
    list all available workspaces

You can also print more details about any of these commands by calling them
after adding the `-h,--help` flag right after the command name.
END
        ;;
        2.1.0)
        cat <<"END"
Yarn Package Manager - 2.1.0

  $ yarn <command>

Where <command> is one of:

  yarn add [--json] [-E,--exact] [-T,--tilde] [-C,--caret] [-D,--dev] [-P,--peer] [-O,--optional] [--prefer-dev] [-i,--interactive] [--cached] ...
    add dependencies to the project

  yarn bin [-v,--verbose] [--json] [name]
    get the path to a binary script

  yarn cache clean [--mirror] [--all]
    remove the shared cache files

  yarn config [-v,--verbose] [--why] [--json]
    display the current configuration

  yarn config get [--json] [--no-redacted] <name>
    read a configuration settings

  yarn config set [--json] <name> <value>
    change a configuration settings

  yarn dlx [-p,--package #0] [-q,--quiet] <command> ...
    run a package in a temporary environment

  yarn exec <commandName> ...
    execute a shell command

  yarn init [-p,--private] [-w,--workspace] [-i,--install]
    create a new package

  yarn install [--json] [--immutable] [--immutable-cache] [--check-cache] [--inline-builds]
    install the project dependencies

  yarn link [--all] [-p,--private] [-r,--relative] <destination>
    connect the local project to another one

  yarn node ...
    run node with the hook already setup

  yarn npm info [-f,--fields #0] [--json] ...
    show information about a package

  yarn pack [--install-if-needed] [-n,--dry-run] [--json] [-o,--out #0] [--filename #0]
    generate a tarball from the active workspace

  yarn patch <package>
    This command will cause a package to be extracted in a temporary directory (under a folder named "patch-workdir"). This folder will be editable at will; running `yarn patch` inside it will then cause Yarn to generate a patchfile and register it into your top-level manifest (cf the `patch:` protocol).

  yarn patch-commit <patchFolder>
    This will turn the folder passed in parameter into a patchfile suitable for consumption with the `patch:` protocol.
Only folders generated through `yarn patch` are accepted as valid input for `yarn patch-commit`.

  yarn rebuild ...
    rebuild the project's native packages

  yarn remove [-A,--all] ...
    remove dependencies from the project

  yarn run [--inspect] [--inspect-brk] <scriptName> ...
    run a script defined in the package.json

  yarn set resolution [-s,--save] <descriptor> <resolution>
    enforce a package resolution

  yarn set version [--only-if-needed] <version>
    lock the Yarn version used by the project

  yarn set version from sources [--path #0] [--repository #0] [--branch #0] [--plugin #0] [--no-minify] [-f,--force]
    build Yarn from master

  yarn unplug ...
    force the unpacking of a list of packages

  yarn up [-i,--interactive] [-v,--verbose] [-E,--exact] [-T,--tilde] [-C,--caret] ...
    upgrade dependencies across the project

  yarn why [-R,--recursive] [--peers] <package>
    display the reason why a package is needed

Npm-related commands:

  yarn npm login [-s,--scope #0] [--publish]
    store new login info to access the npm registry

  yarn npm logout [-s,--scope #0] [--publish] [-A,--all]
    logout of the npm registry

  yarn npm publish [--access #0] [--tag #0] [--tolerate-republish]
    publish the active workspace to the npm registry

  yarn npm whoami [-s,--scope #0] [--publish]
    display the name of the authenticated user

Plugin-related commands:

  yarn plugin import <name>
    download a plugin

  yarn plugin import from sources [--path #0] [--repository #0] [--branch #0] [--no-minify] [-f,--force] <name>
    build a plugin from sources

  yarn plugin list [--json]
    list the available official plugins

  yarn plugin remove <name>
    remove a plugin

  yarn plugin runtime [--json]
    list the active plugins

Workspace-related commands:

  yarn workspace <workspaceName> <commandName> ...
    run a command within the specified workspace

  yarn workspaces list [-v,--verbose] [--json]
    list all available workspaces

You can also print more details about any of these commands by calling them
after adding the `-h,--help` flag right after the command name.
END
        ;;
    esac
}

run_mocked_yarn_command() {
  if [[ $1 == '--help' ]]; then
    yarn_help_mock
  elif [[ $1 == '--version' ]]; then
    yarn_get_version_from_yarnrc
  else
    command yarn "$@"
  fi
}

generate_yarn_expected_command_words() {
  local version="$1"
  declare -i index=0

  case "${version}" in
    2.4.2)
    EXPECTED_Y2C_COMMAND_TOKENS_242_0=("yarn" "add" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_1=("yarn" "bin" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name")
    EXPECTED_Y2C_COMMAND_TOKENS_242_2=("yarn" "cache" "clean" "[--mirror,--all" "[--mirror,--all")
    EXPECTED_Y2C_COMMAND_TOKENS_242_3=("yarn" "config" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json")
    EXPECTED_Y2C_COMMAND_TOKENS_242_4=("yarn" "config" "get" "[--json,--no-redacted" "[--json,--no-redacted" "<name")
    EXPECTED_Y2C_COMMAND_TOKENS_242_5=("yarn" "config" "set" "[--json,-H|--home" "[--json,-H|--home" "<name" "<value")
    EXPECTED_Y2C_COMMAND_TOKENS_242_6=("yarn" "dedupe" "[-s|--strategy #0,-c|--check,--json" "[-s|--strategy #0,-c|--check,--json" "[-s|--strategy #0,-c|--check,--json" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_7=("yarn" "dlx" "[-p|--package #0,-q|--quiet" "[-p|--package #0,-q|--quiet" "<command" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_8=("yarn" "exec" "<commandName" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_9=("yarn" "explain" "peer-requirements" "[hash")
    EXPECTED_Y2C_COMMAND_TOKENS_242_10=("yarn" "info" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_11=("yarn" "init" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install")
    EXPECTED_Y2C_COMMAND_TOKENS_242_12=("yarn" "install" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds")
    EXPECTED_Y2C_COMMAND_TOKENS_242_13=("yarn" "link" "[-A|--all,-p|--private,-r|--relative" "[-A|--all,-p|--private,-r|--relative" "[-A|--all,-p|--private,-r|--relative" "<destination")
    EXPECTED_Y2C_COMMAND_TOKENS_242_14=("yarn" "node" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_15=("yarn" "npm" "audit" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0")
    EXPECTED_Y2C_COMMAND_TOKENS_242_16=("yarn" "pack" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    EXPECTED_Y2C_COMMAND_TOKENS_242_17=("yarn" "patch" "<package")
    EXPECTED_Y2C_COMMAND_TOKENS_242_18=("yarn" "patch-commit" "<patchFolder")
    EXPECTED_Y2C_COMMAND_TOKENS_242_19=("yarn" "rebuild" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_20=("yarn" "remove" "[-A|--all" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_21=("yarn" "run" "[--inspect,--inspect-brk" "[--inspect,--inspect-brk" "<scriptName" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_22=("yarn" "set" "resolution" "[-s|--save" "<descriptor" "<resolution")
    EXPECTED_Y2C_COMMAND_TOKENS_242_23=("yarn" "set" "version" "[--only-if-needed" "<version")
    EXPECTED_Y2C_COMMAND_TOKENS_242_24=("yarn" "set" "version" "from" "sources" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    EXPECTED_Y2C_COMMAND_TOKENS_242_25=("yarn" "unplug" "[-A|--all,-R|--recursive,--json" "[-A|--all,-R|--recursive,--json" "[-A|--all,-R|--recursive,--json" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_26=("yarn" "up" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_27=("yarn" "why" "[-R|--recursive,--json,--peers" "[-R|--recursive,--json,--peers" "[-R|--recursive,--json,--peers" "<package")
    EXPECTED_Y2C_COMMAND_TOKENS_242_28=("yarn" "npm" "info" "[-f|--fields #0,--json" "[-f|--fields #0,--json" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_29=("yarn" "npm" "login" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_Y2C_COMMAND_TOKENS_242_30=("yarn" "npm" "logout" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all")
    EXPECTED_Y2C_COMMAND_TOKENS_242_31=("yarn" "npm" "publish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish")
    EXPECTED_Y2C_COMMAND_TOKENS_242_32=("yarn" "npm" "tag" "add" "<package" "<tag")
    EXPECTED_Y2C_COMMAND_TOKENS_242_33=("yarn" "npm" "tag" "list" "[--json,package" "[--json,package")
    EXPECTED_Y2C_COMMAND_TOKENS_242_34=("yarn" "npm" "tag" "remove" "<package" "<tag")
    EXPECTED_Y2C_COMMAND_TOKENS_242_35=("yarn" "npm" "whoami" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_Y2C_COMMAND_TOKENS_242_36=("yarn" "plugin" "import" "<name")
    EXPECTED_Y2C_COMMAND_TOKENS_242_37=("yarn" "plugin" "import" "from" "sources" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "<name")
    EXPECTED_Y2C_COMMAND_TOKENS_242_38=("yarn" "plugin" "list" "[--json")
    EXPECTED_Y2C_COMMAND_TOKENS_242_39=("yarn" "plugin" "remove" "<name")
    EXPECTED_Y2C_COMMAND_TOKENS_242_40=("yarn" "plugin" "runtime" "[--json")
    EXPECTED_Y2C_COMMAND_TOKENS_242_41=("yarn" "workspace" "<workspaceName" "<commandName" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_42=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "<commandName" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_242_43=("yarn" "workspaces" "list" "[-v|--verbose,--json" "[-v|--verbose,--json")

    EXPECTED_Y2C_COMMAND_TOKENS_LIST_242=()
    for (( index=0; index<44; ++index )); do
      EXPECTED_Y2C_COMMAND_TOKENS_LIST_242+=("EXPECTED_Y2C_COMMAND_TOKENS_242_${index}")
    done
    ;;
    2.1.0)
    EXPECTED_Y2C_COMMAND_TOKENS_210_0=("yarn" "add" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_1=("yarn" "bin" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name")
    EXPECTED_Y2C_COMMAND_TOKENS_210_2=("yarn" "cache" "clean" "[--mirror,--all" "[--mirror,--all")
    EXPECTED_Y2C_COMMAND_TOKENS_210_3=("yarn" "config" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json")
    EXPECTED_Y2C_COMMAND_TOKENS_210_4=("yarn" "config" "get" "[--json,--no-redacted" "[--json,--no-redacted" "<name")
    EXPECTED_Y2C_COMMAND_TOKENS_210_5=("yarn" "config" "set" "[--json" "<name" "<value")
    EXPECTED_Y2C_COMMAND_TOKENS_210_6=("yarn" "dlx" "[-p|--package #0,-q|--quiet" "[-p|--package #0,-q|--quiet" "<command" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_7=("yarn" "exec" "<commandName" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_8=("yarn" "init" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install")
    EXPECTED_Y2C_COMMAND_TOKENS_210_9=("yarn" "install" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds")
    EXPECTED_Y2C_COMMAND_TOKENS_210_10=("yarn" "link" "[--all,-p|--private,-r|--relative" "[--all,-p|--private,-r|--relative" "[--all,-p|--private,-r|--relative" "<destination")
    EXPECTED_Y2C_COMMAND_TOKENS_210_11=("yarn" "node" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_12=("yarn" "npm" "info" "[-f|--fields #0,--json" "[-f|--fields #0,--json" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_13=("yarn" "pack" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    EXPECTED_Y2C_COMMAND_TOKENS_210_14=("yarn" "patch" "<package")
    EXPECTED_Y2C_COMMAND_TOKENS_210_15=("yarn" "patch-commit" "<patchFolder")
    EXPECTED_Y2C_COMMAND_TOKENS_210_16=("yarn" "rebuild" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_17=("yarn" "remove" "[-A|--all" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_18=("yarn" "run" "[--inspect,--inspect-brk" "[--inspect,--inspect-brk" "<scriptName" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_19=("yarn" "set" "resolution" "[-s|--save" "<descriptor" "<resolution")
    EXPECTED_Y2C_COMMAND_TOKENS_210_20=("yarn" "set" "version" "[--only-if-needed" "<version")
    EXPECTED_Y2C_COMMAND_TOKENS_210_21=("yarn" "set" "version" "from" "sources" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    EXPECTED_Y2C_COMMAND_TOKENS_210_22=("yarn" "unplug" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_23=("yarn" "up" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_24=("yarn" "why" "[-R|--recursive,--peers" "[-R|--recursive,--peers" "<package")
    EXPECTED_Y2C_COMMAND_TOKENS_210_25=("yarn" "npm" "login" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_Y2C_COMMAND_TOKENS_210_26=("yarn" "npm" "logout" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all")
    EXPECTED_Y2C_COMMAND_TOKENS_210_27=("yarn" "npm" "publish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish")
    EXPECTED_Y2C_COMMAND_TOKENS_210_28=("yarn" "npm" "whoami" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_Y2C_COMMAND_TOKENS_210_29=("yarn" "plugin" "import" "<name")
    EXPECTED_Y2C_COMMAND_TOKENS_210_30=("yarn" "plugin" "import" "from" "sources" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "<name")
    EXPECTED_Y2C_COMMAND_TOKENS_210_31=("yarn" "plugin" "list" "[--json")
    EXPECTED_Y2C_COMMAND_TOKENS_210_32=("yarn" "plugin" "remove" "<name")
    EXPECTED_Y2C_COMMAND_TOKENS_210_33=("yarn" "plugin" "runtime" "[--json")
    EXPECTED_Y2C_COMMAND_TOKENS_210_34=("yarn" "workspace" "<workspaceName" "<commandName" "...")
    EXPECTED_Y2C_COMMAND_TOKENS_210_35=("yarn" "workspaces" "list" "[-v|--verbose,--json" "[-v|--verbose,--json")

    EXPECTED_Y2C_COMMAND_TOKENS_LIST_210=()
    for (( index=0; index<36; ++index )); do
      EXPECTED_Y2C_COMMAND_TOKENS_LIST_210+=("EXPECTED_Y2C_COMMAND_TOKENS_210_${index}")
    done
    ;;
  esac
}

generate_expected_workspace_commands() {
  local version="$1"
  declare -i index=0

  case "${version}" in
    2.4.2)
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_0=("yarn" "workspace" "<workspaceName" "add" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_1=("yarn" "workspace" "<workspaceName" "bin" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_2=("yarn" "workspace" "<workspaceName" "cache" "clean" "[--mirror,--all" "[--mirror,--all")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_3=("yarn" "workspace" "<workspaceName" "config" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_4=("yarn" "workspace" "<workspaceName" "config" "get" "[--json,--no-redacted" "[--json,--no-redacted" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_5=("yarn" "workspace" "<workspaceName" "config" "set" "[--json,-H|--home" "[--json,-H|--home" "<name" "<value")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_6=("yarn" "workspace" "<workspaceName" "dedupe" "[-s|--strategy #0,-c|--check,--json" "[-s|--strategy #0,-c|--check,--json" "[-s|--strategy #0,-c|--check,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_7=("yarn" "workspace" "<workspaceName" "dlx" "[-p|--package #0,-q|--quiet" "[-p|--package #0,-q|--quiet" "<command" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_8=("yarn" "workspace" "<workspaceName" "exec" "<commandName" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_9=("yarn" "workspace" "<workspaceName" "explain" "peer-requirements" "[hash")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_10=("yarn" "workspace" "<workspaceName" "info" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_11=("yarn" "workspace" "<workspaceName" "init" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_12=("yarn" "workspace" "<workspaceName" "install" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_13=("yarn" "workspace" "<workspaceName" "link" "[-A|--all,-p|--private,-r|--relative" "[-A|--all,-p|--private,-r|--relative" "[-A|--all,-p|--private,-r|--relative" "<destination")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_14=("yarn" "workspace" "<workspaceName" "node" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_15=("yarn" "workspace" "<workspaceName" "npm" "audit" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_16=("yarn" "workspace" "<workspaceName" "pack" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_17=("yarn" "workspace" "<workspaceName" "patch" "<package")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_18=("yarn" "workspace" "<workspaceName" "patch-commit" "<patchFolder")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_19=("yarn" "workspace" "<workspaceName" "rebuild" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_20=("yarn" "workspace" "<workspaceName" "remove" "[-A|--all" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_21=("yarn" "workspace" "<workspaceName" "run" "[--inspect,--inspect-brk" "[--inspect,--inspect-brk" "<scriptName" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_22=("yarn" "workspace" "<workspaceName" "set" "resolution" "[-s|--save" "<descriptor" "<resolution")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_23=("yarn" "workspace" "<workspaceName" "set" "version" "[--only-if-needed" "<version")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_24=("yarn" "workspace" "<workspaceName" "set" "version" "from" "sources" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_25=("yarn" "workspace" "<workspaceName" "unplug" "[-A|--all,-R|--recursive,--json" "[-A|--all,-R|--recursive,--json" "[-A|--all,-R|--recursive,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_26=("yarn" "workspace" "<workspaceName" "up" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_27=("yarn" "workspace" "<workspaceName" "why" "[-R|--recursive,--json,--peers" "[-R|--recursive,--json,--peers" "[-R|--recursive,--json,--peers" "<package")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_28=("yarn" "workspace" "<workspaceName" "npm" "info" "[-f|--fields #0,--json" "[-f|--fields #0,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_29=("yarn" "workspace" "<workspaceName" "npm" "login" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_30=("yarn" "workspace" "<workspaceName" "npm" "logout" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_31=("yarn" "workspace" "<workspaceName" "npm" "publish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_32=("yarn" "workspace" "<workspaceName" "npm" "tag" "add" "<package" "<tag")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_33=("yarn" "workspace" "<workspaceName" "npm" "tag" "list" "[--json,package" "[--json,package")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_34=("yarn" "workspace" "<workspaceName" "npm" "tag" "remove" "<package" "<tag")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_35=("yarn" "workspace" "<workspaceName" "npm" "whoami" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_36=("yarn" "workspace" "<workspaceName" "plugin" "import" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_37=("yarn" "workspace" "<workspaceName" "plugin" "import" "from" "sources" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_38=("yarn" "workspace" "<workspaceName" "plugin" "list" "[--json")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_39=("yarn" "workspace" "<workspaceName" "plugin" "remove" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_40=("yarn" "workspace" "<workspaceName" "plugin" "runtime" "[--json")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_41=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "add" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_42=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "bin" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_43=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "cache" "clean" "[--mirror,--all" "[--mirror,--all")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_44=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "config" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_45=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "config" "get" "[--json,--no-redacted" "[--json,--no-redacted" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_46=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "config" "set" "[--json,-H|--home" "[--json,-H|--home" "<name" "<value")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_47=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "dedupe" "[-s|--strategy #0,-c|--check,--json" "[-s|--strategy #0,-c|--check,--json" "[-s|--strategy #0,-c|--check,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_48=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "dlx" "[-p|--package #0,-q|--quiet" "[-p|--package #0,-q|--quiet" "<command" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_49=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "exec" "<commandName" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_50=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "explain" "peer-requirements" "[hash")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_51=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "info" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_52=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "init" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_53=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "install" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_54=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "link" "[-A|--all,-p|--private,-r|--relative" "[-A|--all,-p|--private,-r|--relative" "[-A|--all,-p|--private,-r|--relative" "<destination")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_55=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "node" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_56=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "audit" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" "[-A|--all,-R|--recursive,--environment #0,--json,--severity #0")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_57=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "pack" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_58=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "patch" "<package")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_59=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "patch-commit" "<patchFolder")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_60=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "rebuild" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_61=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "remove" "[-A|--all" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_62=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "run" "[--inspect,--inspect-brk" "[--inspect,--inspect-brk" "<scriptName" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_63=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "set" "resolution" "[-s|--save" "<descriptor" "<resolution")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_64=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "set" "version" "[--only-if-needed" "<version")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_65=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "set" "version" "from" "sources" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_66=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "unplug" "[-A|--all,-R|--recursive,--json" "[-A|--all,-R|--recursive,--json" "[-A|--all,-R|--recursive,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_67=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "up" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_68=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "why" "[-R|--recursive,--json,--peers" "[-R|--recursive,--json,--peers" "[-R|--recursive,--json,--peers" "<package")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_69=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "info" "[-f|--fields #0,--json" "[-f|--fields #0,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_70=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "login" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_71=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "logout" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_72=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "publish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_73=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "tag" "add" "<package" "<tag")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_74=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "tag" "list" "[--json,package" "[--json,package")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_75=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "tag" "remove" "<package" "<tag")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_76=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "npm" "whoami" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_77=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "plugin" "import" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_78=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "plugin" "import" "from" "sources" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_79=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "plugin" "list" "[--json")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_80=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "plugin" "remove" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_242_81=("yarn" "workspaces" "foreach" "[-A|--all,-j|--jobs #0" "[-A|--all,-j|--jobs #0" "plugin" "runtime" "[--json")

    EXPECTED_WORKSPACE_COMMAND_TOKENS_LIST_242=()
    for (( index=0; index<82; ++index )); do
      EXPECTED_WORKSPACE_COMMAND_TOKENS_LIST_242+=("EXPECTED_WORKSPACE_COMMAND_TOKENS_242_${index}")
    done
    ;;
    2.1.0)
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_0=("yarn" "workspace" "<workspaceName" "add" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_1=("yarn" "workspace" "<workspaceName" "bin" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name" "[-v|--verbose,--json,name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_2=("yarn" "workspace" "<workspaceName" "cache" "clean" "[--mirror,--all" "[--mirror,--all")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_3=("yarn" "workspace" "<workspaceName" "config" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json" "[-v|--verbose,--why,--json")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_4=("yarn" "workspace" "<workspaceName" "config" "get" "[--json,--no-redacted" "[--json,--no-redacted" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_5=("yarn" "workspace" "<workspaceName" "config" "set" "[--json" "<name" "<value")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_6=("yarn" "workspace" "<workspaceName" "dlx" "[-p|--package #0,-q|--quiet" "[-p|--package #0,-q|--quiet" "<command" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_7=("yarn" "workspace" "<workspaceName" "exec" "<commandName" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_8=("yarn" "workspace" "<workspaceName" "init" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install" "[-p|--private,-w|--workspace,-i|--install")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_9=("yarn" "workspace" "<workspaceName" "install" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" "[--json,--immutable,--immutable-cache,--check-cache,--inline-builds")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_10=("yarn" "workspace" "<workspaceName" "link" "[--all,-p|--private,-r|--relative" "[--all,-p|--private,-r|--relative" "[--all,-p|--private,-r|--relative" "<destination")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_11=("yarn" "workspace" "<workspaceName" "node" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_12=("yarn" "workspace" "<workspaceName" "npm" "info" "[-f|--fields #0,--json" "[-f|--fields #0,--json" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_13=("yarn" "workspace" "<workspaceName" "pack" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" "[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_14=("yarn" "workspace" "<workspaceName" "patch" "<package")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_15=("yarn" "workspace" "<workspaceName" "patch-commit" "<patchFolder")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_16=("yarn" "workspace" "<workspaceName" "rebuild" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_17=("yarn" "workspace" "<workspaceName" "remove" "[-A|--all" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_18=("yarn" "workspace" "<workspaceName" "run" "[--inspect,--inspect-brk" "[--inspect,--inspect-brk" "<scriptName" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_19=("yarn" "workspace" "<workspaceName" "set" "resolution" "[-s|--save" "<descriptor" "<resolution")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_20=("yarn" "workspace" "<workspaceName" "set" "version" "[--only-if-needed" "<version")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_21=("yarn" "workspace" "<workspaceName" "set" "version" "from" "sources" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_22=("yarn" "workspace" "<workspaceName" "unplug" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_23=("yarn" "workspace" "<workspaceName" "up" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" "...")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_24=("yarn" "workspace" "<workspaceName" "why" "[-R|--recursive,--peers" "[-R|--recursive,--peers" "<package")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_25=("yarn" "workspace" "<workspaceName" "npm" "login" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_26=("yarn" "workspace" "<workspaceName" "npm" "logout" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all" "[-s|--scope #0,--publish,-A|--all")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_27=("yarn" "workspace" "<workspaceName" "npm" "publish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish" "[--access #0,--tag #0,--tolerate-republish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_28=("yarn" "workspace" "<workspaceName" "npm" "whoami" "[-s|--scope #0,--publish" "[-s|--scope #0,--publish")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_29=("yarn" "workspace" "<workspaceName" "plugin" "import" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_30=("yarn" "workspace" "<workspaceName" "plugin" "import" "from" "sources" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_31=("yarn" "workspace" "<workspaceName" "plugin" "list" "[--json")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_32=("yarn" "workspace" "<workspaceName" "plugin" "remove" "<name")
    EXPECTED_WORKSPACE_COMMAND_TOKENS_210_33=("yarn" "workspace" "<workspaceName" "plugin" "runtime" "[--json")
    ;;
  esac
}

setup() {
  Y2C_TESTING_MODE=1
  cd "$( dirname "$BATS_TEST_FILENAME" )/yarn-repo"
}

validate_yarn_command_words() {
  declare -i command_line_num="$3"
  declare -i command_index=0
  declare -i word_index=0

  local testing_yarn_command_words_ref="$1"
  local expected_yarn_command_words_var_name_prefix="$2"
  local yarn_command_words_ref=""
  local validating_command_words_ref=""

  command_index=0
  for yarn_command_words_ref in "${!testing_yarn_command_words_ref}"; do
    yarn_command_words_ref="${yarn_command_words_ref}[@]"
    word_index=0
    for words in "${!yarn_command_words_ref}"; do
      validating_command_words_ref="${expected_yarn_command_words_var_name_prefix}${command_index}[$word_index]"
      [ "$words" ]
      [ "${!validating_command_words_ref}" ]
      [ "$words" == "${!validating_command_words_ref}" ]
      word_index+=1
    done

    [ $word_index -ne 0 ]
    command_index+=1
  done

  [ $command_index -eq $command_line_num ]
}

@test "y2c_detect_environment" {
  . lib.sh

  y2c_detect_environment

  if [ "${BASH_VERSINFO[0]}" -eq 3 ]; then
    [ "$IS_SUPPORT_DECLARE_N_FLAG" -eq 0 ]
    [ "$IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT" -eq 0 ]
    [ "$IS_SUPPORT_UPPER_CASE_TRANSFORM" -eq 0 ]
  elif [ "${BASH_VERSINFO[0]}" -gt 3 ]; then
    [ "$IS_SUPPORT_DECLARE_N_FLAG" -eq 1 ]
    [ "$IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT" -eq 1 ]
    [ "$IS_SUPPORT_UPPER_CASE_TRANSFORM" -eq 1 ]
  fi
}

@test "yarn_get_version_from_yarnrc" {
  local yarn_version

  yarn() {
    if [[ $1 == '--version' ]]; then
      yarn_get_version_from_yarnrc
      return $?
    fi
    command yarn "$@"
  }

  cd test1
  yarn_version=$(yarn --version)
  [ "$yarn_version" == "2.4.2" ]

  cd ../test2
  yarn_version=$(yarn --version)
  [ "$yarn_version" == "1.22.10" ]

  cd ../test3
  yarn_version=$(yarn --version)
  [ "$yarn_version" == "2.1.0" ]

  cd ../test1/workspace-a
  yarn_version=$(yarn --version)
  [ "$yarn_version" == "2.4.2" ]

  cd ../../test3/packages/workspace-a
  yarn_version=$(yarn --version)
  [ "$yarn_version" == "2.1.0" ]
}

@test "y2c_get_var_name" {
  # The variable assignment by declare command makes them be local variables,
  # so we can't put the source command in the setup function.
  . lib.sh

  local result=""
  local decoded_str_by_base64=""
  local sources=()

  result=$(y2c_get_var_name "/home/test/12345/file \(111\)")
  [ "$result" == "L2hvbWUvdGVzdC8xMjM0NS9maWxlIFwoMTExXCk_" ]

  result=$(y2c_get_var_name "/tag/@12345" "PREFIX_")
  [ "$result" == 'PREFIX_L3RhZy9AMTIzNDU_' ]

  sources=("/test/123/folder1 \[a\]" "/test/123/folder1 \[b\]" "/test/123/folder1 \[b\]")
  result=$( y2c_get_var_name "sources[@]" '' 1 )

  [ "$result" == "L3Rlc3QvMTIzL2ZvbGRlcjEgXFthXF0_"$'\n'"L3Rlc3QvMTIzL2ZvbGRlcjEgXFtiXF0_"$'\n'"L3Rlc3QvMTIzL2ZvbGRlcjEgXFtiXF0_" ]
}

@test "y2c_setup (init at workspace's package folder)" {
  local is_y2c_failed=1

  . lib.sh

  y2c_generate_yarn_command_list() {
    :
  }

  y2c_generate_workspace_packages() {
    :
  }

  y2c_generate_system_executables() {
    :
  }

  yarn() {
    run_mocked_yarn_command "$@"
  }

  y2c_detect_environment

  cd test3/packages/workspace-a
  y2c_setup || is_y2c_failed=0

  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "2.1.0" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "Mi4xLjA_" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz -eq 1 ]
  [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD%/packages/workspace-a}" ]
  [ $Y2C_IS_YARN_2_REPO -eq 1 ]
  [ $Y2C_IS_IN_WORKSPACE_PACKAGE -eq 1 ]

  cd ../../
  y2c_setup || is_y2c_failed=0

  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "2.1.0" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "Mi4xLjA_" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz -eq 1 ]
  [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD%/packages/workspace-a}" ]
  [ $Y2C_IS_YARN_2_REPO -eq 1 ]
  [ $Y2C_IS_IN_WORKSPACE_PACKAGE -eq 0 ]

  cd packages/workspace-a
  y2c_setup || is_y2c_failed=0

  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "2.1.0" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "Mi4xLjA_" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz -eq 1 ]
  [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD%/packages/workspace-a}" ]
  [ $Y2C_IS_YARN_2_REPO -eq 1 ]
  [ $Y2C_IS_IN_WORKSPACE_PACKAGE -eq 1 ]
}

@test "y2c_setup" {
  . lib.sh

  local is_y2c_failed=1

  y2c_generate_yarn_command_list() {
    :
  }

  y2c_generate_workspace_packages() {
    :
  }

  y2c_generate_system_executables() {
    [ "$1" = "${PATH}" ]
  }

  yarn() {
    run_mocked_yarn_command "$@"
  }

  cd test1
  y2c_detect_environment
  y2c_setup

  [ $Y2C_SETUP_HIT_CACHE -eq 0 ]
  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "2.4.2" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "Mi40LjI_" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx -eq 1 ]
  [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD}" ]
  [ $Y2C_IS_YARN_2_REPO -eq 1 ]
  [ $Y2C_IS_IN_WORKSPACE_PACKAGE -eq 0 ]

  cd ../test2

  y2c_setup || is_y2c_failed=0

  [ $is_y2c_failed ]
  [ $Y2C_SETUP_HIT_CACHE -eq 0 ]
  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "2.4.2" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "Mi40LjI_" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx -eq 1 ]
  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "1.22.10" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "MS4yMi4xMA__" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy -eq 0 ]
  [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD}" ]
  [ $Y2C_IS_YARN_2_REPO -eq 0 ]
  [ $Y2C_IS_IN_WORKSPACE_PACKAGE -eq 0 ]

  cd ../test1/workspace-b
  y2c_setup

  [ $Y2C_SETUP_HIT_CACHE -eq 1 ]
  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "2.4.2" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "Mi40LjI_" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx -eq 1 ]
  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "1.22.10" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "MS4yMi4xMA__" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy -eq 0 ]
  [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD%/workspace-b}" ]
  [ $Y2C_IS_YARN_2_REPO -eq 1 ]
  [ $Y2C_IS_IN_WORKSPACE_PACKAGE -eq 1 ]

  cd ../../test3/packages/workspace-a
  y2c_setup

  [ $Y2C_SETUP_HIT_CACHE -eq 0 ]
  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "2.4.2" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "Mi40LjI_" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx -eq 1 ]
  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "1.22.10" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "MS4yMi4xMA__" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy -eq 0 ]
  [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "2.1.0" ]
  [ $Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "Mi4xLjA_" ]
  [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz -eq 1 ]
  [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD%/packages/workspace-a}" ]
  [ $Y2C_IS_YARN_2_REPO -eq 1 ]
  [ $Y2C_IS_IN_WORKSPACE_PACKAGE -eq 1 ]
}

@test "y2c_generate_yarn_command_list" {
  . lib.sh

  y2c_expand_yarn_workspace_command_list() {
    :
  }

  yarn() {
    run_mocked_yarn_command "$@"
  }

  cd test1
  y2c_detect_environment

  Y2C_YARN_VERSION=$(y2c_is_yarn_2)
  Y2C_YARN_BASE64_VERSION=$(y2c_get_var_name "${Y2C_YARN_VERSION}")
  y2c_generate_yarn_command_list
  generate_yarn_expected_command_words "${Y2C_YARN_VERSION}"

  [ $Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_ ]
  [ ! $Y2C_COMMAND_TOKENS_LIST_VER_Mi4xLjA_ ]
  validate_yarn_command_words "Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_[@]" "EXPECTED_Y2C_COMMAND_TOKENS_242_" 44

  cd ../test3

  Y2C_YARN_VERSION=$(y2c_is_yarn_2)
  Y2C_YARN_BASE64_VERSION=$(y2c_get_var_name "${Y2C_YARN_VERSION}")
  y2c_generate_yarn_command_list
  generate_yarn_expected_command_words "${Y2C_YARN_VERSION}"

  [ $Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_ ]
  [ $Y2C_COMMAND_TOKENS_LIST_VER_Mi4xLjA_ ]
  validate_yarn_command_words "Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_[@]" "EXPECTED_Y2C_COMMAND_TOKENS_242_" 44
  validate_yarn_command_words "Y2C_COMMAND_TOKENS_LIST_VER_Mi4xLjA_[@]" "EXPECTED_Y2C_COMMAND_TOKENS_210_" 36
}

@test "y2c_set_package_name_path_map" {
  . lib.sh

  local package_names=()
  local package_paths=()

  yarn() {
    run_mocked_yarn_command "$@"
  }

  y2c_detect_environment

  Y2C_CURRENT_ROOT_REPO_BASE64_PATH="FAKEBASE64"
  package_names=("workspace-a" "workspace-b")
  package_paths=("/yarn-repo/packages/workspace-a" "/yarn-repo/packages/workspace-b")
  y2c_set_package_name_path_map "package_names[@]" "package_paths[@]"
  [ "$Y2C_PACKAGE_NAME_PATH_FAKEBASE64_d29ya3NwYWNlLWE_" == "/yarn-repo/packages/workspace-a" ]
  [ "$Y2C_PACKAGE_NAME_PATH_FAKEBASE64_d29ya3NwYWNlLWI_" == "/yarn-repo/packages/workspace-b" ]

  package_names=("@package1")
  package_paths=("/yarn-repo/packages/package-1")
  y2c_set_package_name_path_map "package_names[@]" "package_paths[@]"
  [ "$Y2C_PACKAGE_NAME_PATH_FAKEBASE64_QHBhY2thZ2Ux" = "/yarn-repo/packages/package-1" ]
}

@test "y2c_generate_workspace_packages" {
  . lib.sh

  y2c_set_package_name_path_map() {
    local package_names=("${!1}")
    local package_paths=("${!2}")

    [ ${#package_names[@]} -eq ${#package_paths[@]} ]
  }

  y2c_detect_environment

  cd test1
  Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
  Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
  y2c_generate_workspace_packages
  [ "${Y2C_WORKSPACE_PACKAGES_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx[*]}" == "wrk-a wrk-b wrk-c" ]

  cd ../test3
  Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
  Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
  y2c_generate_workspace_packages
  [ "${Y2C_WORKSPACE_PACKAGES_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz[*]}" == "wrk-a wrk-b wrk-c" ]
}

@test "y2c_get_identified_token" {
  declare -i status=0
  local delimiter=""
  local word=""
  local result=""

  . lib.sh

  generate_yarn_expected_command_words "2.4.2"

  y2c_get_identified_token "${EXPECTED_Y2C_COMMAND_TOKENS_242_0[2]}" || status=$?
  [ $status -eq "$Y2C_YARN_WORD_IS_OPTION" ]

  result=""
  for word in "${Y2C_TMP_IDENTIFIED_TOKENS}"; do
    result+="${delimiter}${word}"
    delimiter=","
  done
  [ "$result" == "${Y2C_TMP_IDENTIFIED_TOKENS}" ]

  status=0
  y2c_get_identified_token "${EXPECTED_Y2C_COMMAND_TOKENS_242_120[1]}" || status=$?
  [ $status -eq "$Y2C_YARN_WORD_IS_ORDER" ]

  status=0
  y2c_get_identified_token "${EXPECTED_Y2C_COMMAND_TOKENS_242_22[5]}" || status=$?
  [ $status -eq "$Y2C_YARN_WORD_IS_VARIABLE" ]
}

@test "y2c_expand_workspaceName_variable" {
  . lib.sh

  y2c_set_package_name_path_map() {
    :
  }

  y2c_detect_environment

  cd test1
  Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
  Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
  y2c_generate_workspace_packages
  y2c_expand_workspaceName_variable

  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" == "${Y2C_WORKSPACE_PACKAGES_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx[*]}" ]

  cd ../test3

  Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
  Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
  y2c_generate_workspace_packages
  y2c_expand_workspaceName_variable

  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" == "${Y2C_WORKSPACE_PACKAGES_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz[*]}" ]
}

@test "y2c_set_expand_var" {
  . lib.sh

  y2c_set_package_name_path_map() {
    :
  }

  y2c_detect_environment

  cd test1

  Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
  Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
  y2c_generate_workspace_packages
  y2c_set_expand_var "<workspaceName"

  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" == "${Y2C_WORKSPACE_PACKAGES_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx[*]}" ]

  y2c_set_expand_var "tag"
  [ ${#Y2C_TMP_EXPANDED_VAR_RESULT[@]} == 1 ]
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" == "tag" ]

  y2c_set_expand_var "<tag"
  [ ${#Y2C_TMP_EXPANDED_VAR_RESULT[@]} == 1 ]
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" == "tag" ]

  cd ../test3

  Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
  Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
  y2c_generate_workspace_packages
  y2c_set_expand_var "<workspaceName"

  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" == "${Y2C_WORKSPACE_PACKAGES_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz[*]}" ]
}

@test "y2c_expand_yarn_workspace_command_list" {
  . lib.sh
  local workspace_commands=()
  declare -i next_index=0
  declare -i total_len=0
  declare -i expanded_workspace_commands_len=0
  declare -i index=0
  declare -i start_expanding_index=0

  y2c_detect_environment

  yarn() {
    run_mocked_yarn_command "$@"
  }

  generate_yarn_expected_command_words "2.4.2"
  generate_expected_workspace_commands "2.4.2"

  start_expanding_index=${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[@]}
  Y2C_YARN_BASE64_VERSION="Mi40LjIK"
  y2c_expand_yarn_workspace_command_list "EXPECTED_Y2C_COMMAND_TOKENS_242_41" "EXPECTED_Y2C_COMMAND_TOKENS_LIST_242"
  total_len=${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[@]}
  expanded_workspace_commands_len=$(( total_len - start_expanding_index ))
  [ $expanded_workspace_commands_len -eq 41 ]

  next_index=${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[@]}
  Y2C_YARN_BASE64_VERSION="Mi40LjIK"
  y2c_expand_yarn_workspace_command_list "EXPECTED_Y2C_COMMAND_TOKENS_242_42" "EXPECTED_Y2C_COMMAND_TOKENS_LIST_242"
  total_len=${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[@]}
  expanded_workspace_commands_len=$(( total_len - next_index ))
  [ $expanded_workspace_commands_len -eq 41 ]

  workspace_commands=()
  for (( index=$start_expanding_index; index<$total_len; ++index )); do
    workspace_commands+=("${EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[$index]}")
  done

  validate_yarn_command_words "workspace_commands[@]" "EXPECTED_WORKSPACE_COMMAND_TOKENS_242_" 82

  generate_yarn_expected_command_words "2.1.0"
  generate_expected_workspace_commands "2.1.0"

  next_index=${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_210[@]}
  Y2C_YARN_BASE64_VERSION="Mi4xLjAK"
  y2c_expand_yarn_workspace_command_list "EXPECTED_Y2C_COMMAND_TOKENS_210_34" "EXPECTED_Y2C_COMMAND_TOKENS_LIST_210"
  total_len=${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_210[@]}
  expanded_workspace_commands_len=$(( total_len - next_index ))

  [ $expanded_workspace_commands_len -eq 34 ]

  workspace_commands=()
  for (( index=$next_index; index<$total_len; ++index )); do
    workspace_commands+=("${EXPECTED_Y2C_COMMAND_TOKENS_LIST_210[$index]}")
  done

  validate_yarn_command_words "workspace_commands[@]" "EXPECTED_WORKSPACE_COMMAND_TOKENS_210_" 34
}

@test "y2c_set_alternative_options" {
  . lib.sh

  y2c_set_alternative_options "-D|--dev"

  [ "${Y2C_TMP_ALTERNATIVE_OPTIONS[0]}" == "-D" ]
  [ "${Y2C_TMP_ALTERNATIVE_OPTIONS[1]}" == "--dev" ]
}

@test "y2c_add_word_to_comreply" {
  . lib.sh

  COMPREPLY=()
  COMP_WORDS=("yarn" "add" "--json")
  y2c_add_word_to_comreply "--json" "--"
  [ "${COMPREPLY[*]}" == "" ]

  COMPREPLY=()
  COMP_WORDS=("yarn" "add" "--json")
  y2c_add_word_to_comreply "--interactive" "--"
  [ "${COMPREPLY[*]}" == "--interactive" ]

  COMPREPLY=()
  COMP_WORDS=("yarn" "config" "g")
  y2c_add_word_to_comreply "add" "g"
  y2c_add_word_to_comreply "get" "g"
  y2c_add_word_to_comreply "get" "g"
  y2c_add_word_to_comreply "gets" "g"
  y2c_add_word_to_comreply "set" "g"
  [ "${COMPREPLY[*]}" == "get get gets" ]

  COMPREPLY=()
  COMP_WORDS=("yarn" "workspace" "@test" "add" "-i" "--json" "")
  y2c_add_word_to_comreply "workspace" ""
  y2c_add_word_to_comreply "--interactive" ""
  y2c_add_word_to_comreply "-i" ""
  y2c_add_word_to_comreply "--json" ""
  [ "${COMPREPLY[*]}" == "--interactive" ]

  COMPREPLY=()
  COMP_WORDS=("yarn" "workspace" "@test" "add" "-i" "--json" "--")
  y2c_add_word_to_comreply "-D" "--"
  y2c_add_word_to_comreply "--dev" "--"
  y2c_add_word_to_comreply "-O" "--"
  y2c_add_word_to_comreply "--option" "--"
  [ "${COMPREPLY[*]}" == "--dev --option" ]

  COMPREPLY=()
  COMP_WORDS=("yarn" "workspace" "@test" "add" "--interactive" "-")
  y2c_add_word_to_comreply "-D" "-"
  y2c_add_word_to_comreply "--dev" "-"
  y2c_add_word_to_comreply "-O" "-"
  y2c_add_word_to_comreply "--option" "-"
  y2c_add_word_to_comreply "-i" "-"
  [ "${COMPREPLY[*]}" == "-D --dev -O --option -i" ]
}

@test "y2c_add_word_candidates" {
  . lib.sh

  local result=()
  COMPREPLY=()
  y2c_add_word_to_comreply() {
    result+=("$1" "$2")
  }

  y2c_set_expand_var() {
    Y2C_TMP_EXPANDED_VAR_RESULT=("@test1" "@test2" "@test3")
  }

  COMP_WORDS=("yarn" "a")

  set +e
  y2c_add_word_candidates "add" "a"
  set -e

  [ "${result[0]}" == "add" ]
  [ "${result[1]}" == "a" ]

  set +e
  COMP_WORDS=("yarn" "add" "")
  COMPREPLY=()
  result=()
  y2c_add_word_candidates "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" ""
  set -e
  [ "${COMPREPLY[*]}" == "--json -E --exact -T --tilde -C --caret -D --dev -P --peer -O --optional --prefer-dev -i --interactive --cached" ]

  set +e
  COMP_WORDS=("yarn" "add" "--")
  COMPREPLY=()
  y2c_add_word_candidates "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "--"
  set -e
  [ "${COMPREPLY[*]}" == "--json --exact --tilde --caret --dev --peer --optional --prefer-dev --interactive --cached" ]

  set +e
  COMP_WORDS=("yarn" "add" "-E" "--tilde" "--dev" "-")
  COMPREPLY=()
  result=()
  y2c_add_word_candidates "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "-"
  set -e
  [ "${COMPREPLY[*]}" == "--json -C --caret -P --peer -O --optional --prefer-dev -i --interactive --cached" ]

  set +e
  COMP_WORDS=("yarn" "add" "--json" "--dev" "-T" "--caret" "--optional" "--prefer-dev" "-i" "--")
  COMPREPLY=()
  result=()
  y2c_add_word_candidates "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" "--"
  set -e
  [ "${COMPREPLY[*]}" == "--exact --peer --cached" ]

  set +e
  COMP_WORDS=("yarn" "workspace" "@")
  COMPREPLY=()
  result=()
  y2c_add_word_candidates "<workspaceName" "@"
  set -e
  [ "${result[*]}" == "@test1 @ @test2 @ @test3 @" ]

  set +e
  COMP_WORDS=("yarn" "run" "--inspect-brk" "-")
  COMPREPLY=()
  result=()
  y2c_add_word_candidates "[--inspect-brk,--inspect" "-"
  set -e
  [ "${COMPREPLY[*]}" == "--inspect" ]
}

@test "y2c_add_word_candidates( option with #[number] )" {
  . lib.sh

  local result=()
  COMPREPLY=()
  y2c_add_word_to_comreply() {
    result+=("$1" "$2")
  }

  y2c_set_expand_var() {
    Y2C_TMP_EXPANDED_VAR_RESULT=("@test1" "@test2" "@test3")
  }

  set +e
  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--path" "test" "")
  COMPREPLY=()
  result=()
  y2c_add_word_candidates "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "-"
  set -e
  [ "${COMPREPLY[*]}" == "--repository #0 --branch #0 --no-minify -f --force" ]

  set +e
  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--path" "test" "--repository" "test2" "-")
  COMPREPLY=()
  result=()
  y2c_add_word_candidates "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" "-"
  set -e
  [ "${COMPREPLY[*]}" == "--branch #0 --no-minify -f --force" ]

  set +e
  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--path" "test" "--repository" "test2" "-f" "")
  COMPREPLY=()
  result=()
  y2c_add_word_candidates "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" ""
  set -e
  [ "${COMPREPLY[*]}" == "--branch #0 --no-minify" ]
}

@test "y2c_is_commandline_word_match_option" {
  . lib.sh
  declare -i status=0

  COMP_WORDS=("yarn" "npm" "logout" "-s" "")
  COMPREPLY=()
  y2c_is_commandline_word_match_option "-s" "-s|--scope #0" 3
  [ $Y2C_TMP_OPTION_WORDS_NUM -eq 1 ]

  COMP_WORDS=("yarn" "npm" "logout" "--scope" "")
  COMPREPLY=()
  y2c_is_commandline_word_match_option "--scope" "-s|--scope #0" 3 || status=$?
  [ $Y2C_TMP_OPTION_WORDS_NUM -eq 2 ]
  [ $status -eq $Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION ]
  [ "${COMPREPLY[*]}" == "#0" ]

  COMP_WORDS=("yarn" "npm" "logout" "--option" "test" "")
  COMPREPLY=()
  y2c_is_commandline_word_match_option "--option" "-o|--option #0 #1" 3 || status=$?
  [ $Y2C_TMP_OPTION_WORDS_NUM -eq 3 ]
  [ $status -eq $Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION ]
  [ "${COMPREPLY[*]}" == "#1" ]

  COMP_WORDS=("yarn" "npm" "logout" "--invalid" "")
  COMPREPLY=()
  y2c_is_commandline_word_match_option "--invalid" "--branch #0" 3 || status=$?
  [ $Y2C_TMP_OPTION_WORDS_NUM -eq 0 ]
  [ $status -eq $Y2C_COMMAND_WORDS_NOT_MATCH_OPTION ]
  [ "${COMPREPLY[*]}" == "" ]
}

@test "y2c_run_yarn_completion" {
  . lib.sh

  y2c_detect_environment

  local yarn_version="2.4.2"
  local result=""
  declare -i index=0

  y2c_add_word_candidates() {
    result+="[$1;$2]"
  }

  y2c_set_expand_var() {
    :
  }

  generate_yarn_expected_command_words "${yarn_version}"
  generate_expected_workspace_commands "${yarn_version}"

  Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_=()
  for (( index=0; index<${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[@]}; ++index )); do
    Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_+=("${EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[$index]}")
  done
  for (( index=0; index<${#EXPECTED_WORKSPACE_COMMAND_TOKENS_LIST_242[@]}; ++index )); do
    Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_+=("${EXPECTED_WORKSPACE_COMMAND_TOKENS_LIST_242[$index]}")
  done

  COMP_WORDS=("yarn" "config" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[[-v|--verbose,--why,--json;][get;][set;]" ]

  COMP_WORDS=("yarn" "add" "--json" "-D" "--optional" "--")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion "--"
  set -e
  [ "$result" == "[[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached;--][...;--]" ]

  COMP_WORDS=("yarn" "workspace" "@test" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  Y2C_TMP_EXPANDED_VAR_RESULT=("@test")
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[<commandName;][add;][bin;][cache;][config;][dedupe;][dlx;][exec;][explain;][info;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;]" ]

  COMP_WORDS=("yarn" "workspace" "@test" "plugin" "i")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  Y2C_TMP_EXPANDED_VAR_RESULT=("@test")
  set +e
  y2c_run_yarn_completion "i"
  set -e
  [ "$result" == "[import;i][list;i][remove;i][runtime;i]" ]

  COMP_WORDS=("yarn" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[add;][bin;][cache;][config;][dedupe;][dlx;][exec;][explain;][info;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;][workspace;][workspaces;]" ]

  COMP_WORDS=("yarn" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  Y2C_IS_IN_WORKSPACE_PACKAGE=1
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[add;][bin;][cache;][config;][dedupe;][dlx;][exec;][explain;][info;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;]" ]
}

@test "y2c_run_yarn_completion(show next non-optional token)" {
  . lib.sh

  y2c_detect_environment

  local yarn_version="2.4.2"
  local result=""
  declare -i index=0

  y2c_add_word_candidates() {
    result+="[$1;$2]"
  }

  y2c_set_expand_var() {
    :
  }

  generate_yarn_expected_command_words "${yarn_version}"
  Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_=()
  for (( index=0; index<${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[@]}; ++index )); do
    Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_+=("${EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[$index]}")
  done

  COMP_WORDS=("yarn" "run" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[[--inspect,--inspect-brk;][<scriptName;]" ]

  COMP_WORDS=("yarn" "run" "--inspect" "-")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion "-"
  set -e
  [ "$result" == "[[--inspect,--inspect-brk;-][<scriptName;-]" ]

  COMP_WORDS=("yarn" "run" "--inspect-brk" "--inspect" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[<scriptName;]" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
   set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--path" "#0" "--repository" "#0" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--path" "#0" "--repository" "#0" "--branch" "#0" "--no-minify" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--path" "#0" "--repository" "#0" "--branch" "#0" "--no-minify" "-f" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[<name;]" ]
}

@test "y2c_run_yarn_completion(optional token with variables)" {
  . lib.sh

  y2c_detect_environment

  local yarn_version="2.4.2"
  local result=""
  declare -i index=0

  y2c_add_word_candidates() {
    result+="[$1;$2]"
  }

  y2c_set_expand_var() {
    :
  }

  generate_yarn_expected_command_words "${yarn_version}"
  Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_=()
  for (( index=0; index<${#EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[@]}; ++index )); do
    Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_+=("${EXPECTED_Y2C_COMMAND_TOKENS_LIST_242[$index]}")
  done


  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--branch" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "" ]
  [ "${COMPREPLY[*]}" == "#0" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--branch" "test" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]" ]

  COMP_WORDS=("yarn" "plugin" "import" "from" "sources" "--branch" "test" "--path" "")
  Y2C_YARN_BASE64_VERSION="Mi40LjI_"
  result=""
  set +e
  y2c_run_yarn_completion ""
  set -e
  [ "$result" == "" ]
  [ "${COMPREPLY[*]}" == "#0" ]
}

@test "y2c_yarn_completion_for_complete" {
  . lib.sh

  declare -i y2c_run_yarn_completion_has_been_called=0
  y2c_run_yarn_completion() {
    y2c_run_yarn_completion_has_been_called=1
  }

  y2c_run_yarn_completion_has_been_called=0
  Y2C_IS_YARN_2_REPO=0
  y2c_yarn_completion_for_complete
  [ $y2c_run_yarn_completion_has_been_called -eq 0 ]

  y2c_run_yarn_completion_has_been_called=0
  Y2C_IS_YARN_2_REPO=1
  y2c_yarn_completion_for_complete
  [ $y2c_run_yarn_completion_has_been_called -eq 1 ]
}

@test "y2c_yarn_completion_main" {
  . lib.sh

  declare -i y2c_detect_environment_called=0
  declare -i y2c_setup_called=0
  declare -i complete_called=0
  declare -i set_y2c_detect_environment_status=0
  declare -i y2c_yarn_completion_main_failed=0

  y2c_detect_environment() {
    y2c_detect_environment_called=1
    return ${set_y2c_detect_environment_status}
  }

  y2c_setup() {
    y2c_setup_called=1
  }

  complete() {
    complete_called=1
  }

  y2c_detect_environment_called=0
  y2c_setup_called=0
  complete_called=0
  set_y2c_detect_environment_status=1
  y2c_yarn_completion_main_failed=0
  y2c_yarn_completion_main || y2c_yarn_completion_main_failed=1
  [ $y2c_yarn_completion_main_failed -eq 1 ]
  [ ${y2c_detect_environment_called} -eq 1 ]
  [ ${y2c_setup_called} -eq 0 ]
  [ ${complete_called} -eq 0 ]

  y2c_detect_environment_called=0
  y2c_setup_called=0
  complete_called=0
  set_y2c_detect_environment_status=0
  y2c_yarn_completion_main_failed=0
  y2c_yarn_completion_main || y2c_yarn_completion_main_failed=1
  [ $y2c_yarn_completion_main_failed -eq 0 ]
  [ ${y2c_detect_environment_called} -eq 1 ]
  [ ${y2c_setup_called} -eq 1 ]
  [ ${complete_called} -eq 1 ]
}

@test "y2c_expand_commandName_variable" {
  . lib.sh

  Y2C_PACKAGE_NAME_PATH_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx_d3JrLWE_="./workspace-a/package.json"
  Y2C_PACKAGE_NAME_PATH_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx_d3JrLWI_="./workspace-b/package.json"
  Y2C_PACKAGE_NAME_PATH_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz_d3JrLWE_="./packages/workspace-a/package.json"
  Y2C_PACKAGE_NAME_PATH_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz_d3JrLWQ_="./packages/workspace-d/package.json"
  cd test1

  COMP_WORDS=("yarn" "add")
  Y2C_TMP_EXPANDED_VAR_RESULT=()
  y2c_detect_environment
  y2c_expand_commandName_variable
  [ ${#Y2C_TMP_EXPANDED_VAR_RESULT[@]} -eq 0 ]

  Y2C_CURRENT_ROOT_REPO_BASE64_PATH="L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx"
  COMP_WORDS=("yarn" "workspace" "wrk-a" "")
  Y2C_TMP_EXPANDED_VAR_RESULT=()
  y2c_detect_environment
  y2c_expand_commandName_variable
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" = "build setup test deploy" ]

  Y2C_CURRENT_ROOT_REPO_BASE64_PATH="L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx"
  COMP_WORDS=("yarn" "workspace" "wrk-b" "")
  Y2C_TMP_EXPANDED_VAR_RESULT=()
  y2c_detect_environment
  y2c_expand_commandName_variable
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" = "dev run start build" ]

  Y2C_CURRENT_ROOT_REPO_BASE64_PATH="L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx"
  COMP_WORDS=("yarn" "workspace" "wrk-b" "")
  Y2C_TMP_EXPANDED_VAR_RESULT=()
  y2c_detect_environment
  y2c_expand_commandName_variable
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" = "dev run start build" ]

  cd ../test3

  Y2C_CURRENT_ROOT_REPO_BASE64_PATH="L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz"
  COMP_WORDS=("yarn" "workspace" "wrk-a" "")
  Y2C_TMP_EXPANDED_VAR_RESULT=()
  y2c_detect_environment
  y2c_expand_commandName_variable
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" = "install uninstall" ]

  Y2C_CURRENT_ROOT_REPO_BASE64_PATH="L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz"
  COMP_WORDS=("yarn" "workspace" "wrk-d" "")
  Y2C_TMP_EXPANDED_VAR_RESULT=()
  y2c_detect_environment
  y2c_expand_commandName_variable
  [ ${#Y2C_TMP_EXPANDED_VAR_RESULT[@]} -eq 0 ]
}

@test "y2c_generate_system_executables" {
  . lib.sh

  Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=0
  y2c_generate_system_executables "/usr/local/bin"

  [ ${#Y2C_SYSTEM_EXECUTABLES[@]} -eq 0 ]

  Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=1
  y2c_generate_system_executables "/usr/local/bin"

  [ "${Y2C_SYSTEM_EXECUTABLES[*]}" = "bash bashbug docker-entrypoint.sh" ]
}

@test "y2c_expand_scriptName_variable" {
 . lib.sh

  cd test1

  y2c_expand_scriptName_variable
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" = "dev test" ]

  cd ./workspace-a
  y2c_expand_scriptName_variable
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" = "build setup test deploy" ]

  cd ../workspace-c
  y2c_expand_scriptName_variable
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" = "" ]

  cd ../
  y2c_expand_scriptName_variable
  [ "${Y2C_TMP_EXPANDED_VAR_RESULT[*]}" = "dev test" ]
}
