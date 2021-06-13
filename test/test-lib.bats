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
    case "${Y2C_TMP_REPO_YARN_VERSION}" in
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

generate_yarn_expected_coomand_words() {
    local version="$1"

    case "${version}" in
        2.4.2)
        EXPECTED_YARN_COMMAND_WORDS_242_0=([0]="yarn" [1]="add" [2]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [3]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [4]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [5]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [6]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [7]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [8]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [9]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [10]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [11]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [12]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [13]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_1=([0]="yarn" [1]="bin" [2]="[-v|--verbose,--json,name" [3]="[-v|--verbose,--json,name" [4]="[-v|--verbose,--json,name" [5]="[-v|--verbose,--json,name")
        EXPECTED_YARN_COMMAND_WORDS_242_2=([0]="yarn" [1]="cache" [2]="clean" [3]="[--mirror,--all" [4]="[--mirror,--all" [5]="[--mirror,--all")
        EXPECTED_YARN_COMMAND_WORDS_242_3=([0]="yarn" [1]="config" [2]="[-v|--verbose,--why,--json" [3]="[-v|--verbose,--why,--json" [4]="[-v|--verbose,--why,--json" [5]="[-v|--verbose,--why,--json")
        EXPECTED_YARN_COMMAND_WORDS_242_4=([0]="yarn" [1]="config" [2]="get" [3]="[--json,--no-redacted" [4]="[--json,--no-redacted" [5]="[--json,--no-redacted" [6]="<name")
        EXPECTED_YARN_COMMAND_WORDS_242_5=([0]="yarn" [1]="config" [2]="set" [3]="[--json,-H|--home" [4]="[--json,-H|--home" [5]="[--json,-H|--home" [6]="<name" [7]="<value")
        EXPECTED_YARN_COMMAND_WORDS_242_6=([0]="yarn" [1]="dedupe" [2]="[-s|--strategy #0,-c|--check,--json" [3]="[-s|--strategy #0,-c|--check,--json" [4]="[-s|--strategy #0,-c|--check,--json" [5]="[-s|--strategy #0,-c|--check,--json" [6]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_7=([0]="yarn" [1]="dlx" [2]="[-p|--package #0,-q|--quiet" [3]="[-p|--package #0,-q|--quiet" [4]="[-p|--package #0,-q|--quiet" [5]="<command" [6]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_8=([0]="yarn" [1]="exec" [2]="<commandName" [3]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_9=([0]="yarn" [1]="explain" [2]="peer-requirements" [3]="[hash" [4]="[hash")
        EXPECTED_YARN_COMMAND_WORDS_242_10=([0]="yarn" [1]="info" [2]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [3]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [4]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [5]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [6]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [7]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [8]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [9]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [10]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [11]="[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json" [12]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_11=([0]="yarn" [1]="init" [2]="[-p|--private,-w|--workspace,-i|--install" [3]="[-p|--private,-w|--workspace,-i|--install" [4]="[-p|--private,-w|--workspace,-i|--install" [5]="[-p|--private,-w|--workspace,-i|--install")
        EXPECTED_YARN_COMMAND_WORDS_242_12=([0]="yarn" [1]="install" [2]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" [3]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" [4]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" [5]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" [6]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" [7]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds" [8]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds")
        EXPECTED_YARN_COMMAND_WORDS_242_13=([0]="yarn" [1]="link" [2]="[-A|--all,-p|--private,-r|--relative" [3]="[-A|--all,-p|--private,-r|--relative" [4]="[-A|--all,-p|--private,-r|--relative" [5]="[-A|--all,-p|--private,-r|--relative" [6]="<destination")
        EXPECTED_YARN_COMMAND_WORDS_242_14=([0]="yarn" [1]="node" [2]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_15=([0]="yarn" [1]="npm" [2]="audit" [3]="[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" [4]="[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" [5]="[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" [6]="[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" [7]="[-A|--all,-R|--recursive,--environment #0,--json,--severity #0" [8]="[-A|--all,-R|--recursive,--environment #0,--json,--severity #0")
        EXPECTED_YARN_COMMAND_WORDS_242_16=([0]="yarn" [1]="pack" [2]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [3]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [4]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [5]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [6]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [7]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
        EXPECTED_YARN_COMMAND_WORDS_242_17=([0]="yarn" [1]="patch" [2]="<package")
        EXPECTED_YARN_COMMAND_WORDS_242_18=([0]="yarn" [1]="patch-commit" [2]="<patchFolder")
        EXPECTED_YARN_COMMAND_WORDS_242_19=([0]="yarn" [1]="rebuild" [2]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_20=([0]="yarn" [1]="remove" [2]="[-A|--all" [3]="[-A|--all" [4]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_21=([0]="yarn" [1]="run" [2]="[--inspect,--inspect-brk" [3]="[--inspect,--inspect-brk" [4]="[--inspect,--inspect-brk" [5]="<scriptName" [6]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_22=([0]="yarn" [1]="set" [2]="resolution" [3]="[-s|--save" [4]="[-s|--save" [5]="<descriptor" [6]="<resolution")
        EXPECTED_YARN_COMMAND_WORDS_242_23=([0]="yarn" [1]="set" [2]="version" [3]="[--only-if-needed" [4]="[--only-if-needed" [5]="<version")
        EXPECTED_YARN_COMMAND_WORDS_242_24=([0]="yarn" [1]="set" [2]="version" [3]="from" [4]="sources" [5]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [6]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [7]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [8]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [9]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [10]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [11]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
        EXPECTED_YARN_COMMAND_WORDS_242_25=([0]="yarn" [1]="unplug" [2]="[-A|--all,-R|--recursive,--json" [3]="[-A|--all,-R|--recursive,--json" [4]="[-A|--all,-R|--recursive,--json" [5]="[-A|--all,-R|--recursive,--json" [6]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_26=([0]="yarn" [1]="up" [2]="[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" [3]="[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" [4]="[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" [5]="[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" [6]="[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret" [7]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_27=([0]="yarn" [1]="why" [2]="[-R|--recursive,--json,--peers" [3]="[-R|--recursive,--json,--peers" [4]="[-R|--recursive,--json,--peers" [5]="[-R|--recursive,--json,--peers" [6]="<package")
        EXPECTED_YARN_COMMAND_WORDS_242_28=([0]="yarn" [1]="npm" [2]="info" [3]="[-f|--fields #0,--json" [4]="[-f|--fields #0,--json" [5]="[-f|--fields #0,--json" [6]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_29=([0]="yarn" [1]="npm" [2]="login" [3]="[-s|--scope #0,--publish" [4]="[-s|--scope #0,--publish" [5]="[-s|--scope #0,--publish")
        EXPECTED_YARN_COMMAND_WORDS_242_30=([0]="yarn" [1]="npm" [2]="logout" [3]="[-s|--scope #0,--publish,-A|--all" [4]="[-s|--scope #0,--publish,-A|--all" [5]="[-s|--scope #0,--publish,-A|--all" [6]="[-s|--scope #0,--publish,-A|--all")
        EXPECTED_YARN_COMMAND_WORDS_242_31=([0]="yarn" [1]="npm" [2]="publish" [3]="[--access #0,--tag #0,--tolerate-republish" [4]="[--access #0,--tag #0,--tolerate-republish" [5]="[--access #0,--tag #0,--tolerate-republish" [6]="[--access #0,--tag #0,--tolerate-republish")
        EXPECTED_YARN_COMMAND_WORDS_242_32=([0]="yarn" [1]="npm" [2]="tag" [3]="add" [4]="<package" [5]="<tag")
        EXPECTED_YARN_COMMAND_WORDS_242_33=([0]="yarn" [1]="npm" [2]="tag" [3]="list" [4]="[--json,package" [5]="[--json,package" [6]="[--json,package")
        EXPECTED_YARN_COMMAND_WORDS_242_34=([0]="yarn" [1]="npm" [2]="tag" [3]="remove" [4]="<package" [5]="<tag")
        EXPECTED_YARN_COMMAND_WORDS_242_35=([0]="yarn" [1]="npm" [2]="whoami" [3]="[-s|--scope #0,--publish" [4]="[-s|--scope #0,--publish" [5]="[-s|--scope #0,--publish")
        EXPECTED_YARN_COMMAND_WORDS_242_36=([0]="yarn" [1]="plugin" [2]="import" [3]="<name")
        EXPECTED_YARN_COMMAND_WORDS_242_37=([0]="yarn" [1]="plugin" [2]="import" [3]="from" [4]="sources" [5]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [6]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [7]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [8]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [9]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [10]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [11]="<name")
        EXPECTED_YARN_COMMAND_WORDS_242_38=([0]="yarn" [1]="plugin" [2]="list" [3]="[--json" [4]="[--json")
        EXPECTED_YARN_COMMAND_WORDS_242_39=([0]="yarn" [1]="plugin" [2]="remove" [3]="<name")
        EXPECTED_YARN_COMMAND_WORDS_242_40=([0]="yarn" [1]="plugin" [2]="runtime" [3]="[--json" [4]="[--json")
        EXPECTED_YARN_COMMAND_WORDS_242_41=([0]="yarn" [1]="workspace" [2]="<workspaceName" [3]="<commandName" [4]="...")
        EXPECTED_YARN_COMMAND_WORDS_242_42=([0]="yarn" [1]="workspaces" [2]="list" [3]="[-v|--verbose,--json" [4]="[-v|--verbose,--json" [5]="[-v|--verbose,--json")
        ;;
        2.1.0)
        EXPECTED_YARN_COMMAND_WORDS_210_0=([0]="yarn" [1]="add" [2]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [3]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [4]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [5]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [6]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [7]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [8]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [9]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [10]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [11]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [12]="[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" [13]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_1=([0]="yarn" [1]="bin" [2]="[-v|--verbose,--json,name" [3]="[-v|--verbose,--json,name" [4]="[-v|--verbose,--json,name" [5]="[-v|--verbose,--json,name")
        EXPECTED_YARN_COMMAND_WORDS_210_2=([0]="yarn" [1]="cache" [2]="clean" [3]="[--mirror,--all" [4]="[--mirror,--all" [5]="[--mirror,--all")
        EXPECTED_YARN_COMMAND_WORDS_210_3=([0]="yarn" [1]="config" [2]="[-v|--verbose,--why,--json" [3]="[-v|--verbose,--why,--json" [4]="[-v|--verbose,--why,--json" [5]="[-v|--verbose,--why,--json")
        EXPECTED_YARN_COMMAND_WORDS_210_4=([0]="yarn" [1]="config" [2]="get" [3]="[--json,--no-redacted" [4]="[--json,--no-redacted" [5]="[--json,--no-redacted" [6]="<name")
        EXPECTED_YARN_COMMAND_WORDS_210_5=([0]="yarn" [1]="config" [2]="set" [3]="[--json" [4]="[--json" [5]="<name" [6]="<value")
        EXPECTED_YARN_COMMAND_WORDS_210_6=([0]="yarn" [1]="dlx" [2]="[-p|--package #0,-q|--quiet" [3]="[-p|--package #0,-q|--quiet" [4]="[-p|--package #0,-q|--quiet" [5]="<command" [6]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_7=([0]="yarn" [1]="exec" [2]="<commandName" [3]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_8=([0]="yarn" [1]="init" [2]="[-p|--private,-w|--workspace,-i|--install" [3]="[-p|--private,-w|--workspace,-i|--install" [4]="[-p|--private,-w|--workspace,-i|--install" [5]="[-p|--private,-w|--workspace,-i|--install")
        EXPECTED_YARN_COMMAND_WORDS_210_9=([0]="yarn" [1]="install" [2]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" [3]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" [4]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" [5]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" [6]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds" [7]="[--json,--immutable,--immutable-cache,--check-cache,--inline-builds")
        EXPECTED_YARN_COMMAND_WORDS_210_10=([0]="yarn" [1]="link" [2]="[--all,-p|--private,-r|--relative" [3]="[--all,-p|--private,-r|--relative" [4]="[--all,-p|--private,-r|--relative" [5]="[--all,-p|--private,-r|--relative" [6]="<destination")
        EXPECTED_YARN_COMMAND_WORDS_210_11=([0]="yarn" [1]="node" [2]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_12=([0]="yarn" [1]="npm" [2]="info" [3]="[-f|--fields #0,--json" [4]="[-f|--fields #0,--json" [5]="[-f|--fields #0,--json" [6]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_13=([0]="yarn" [1]="pack" [2]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [3]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [4]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [5]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [6]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0" [7]="[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
        EXPECTED_YARN_COMMAND_WORDS_210_14=([0]="yarn" [1]="patch" [2]="<package")
        EXPECTED_YARN_COMMAND_WORDS_210_15=([0]="yarn" [1]="patch-commit" [2]="<patchFolder")
        EXPECTED_YARN_COMMAND_WORDS_210_16=([0]="yarn" [1]="rebuild" [2]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_17=([0]="yarn" [1]="remove" [2]="[-A|--all" [3]="[-A|--all" [4]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_18=([0]="yarn" [1]="run" [2]="[--inspect,--inspect-brk" [3]="[--inspect,--inspect-brk" [4]="[--inspect,--inspect-brk" [5]="<scriptName" [6]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_19=([0]="yarn" [1]="set" [2]="resolution" [3]="[-s|--save" [4]="[-s|--save" [5]="<descriptor" [6]="<resolution")
        EXPECTED_YARN_COMMAND_WORDS_210_20=([0]="yarn" [1]="set" [2]="version" [3]="[--only-if-needed" [4]="[--only-if-needed" [5]="<version")
        EXPECTED_YARN_COMMAND_WORDS_210_21=([0]="yarn" [1]="set" [2]="version" [3]="from" [4]="sources" [5]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [6]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [7]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [8]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [9]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [10]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force" [11]="[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
        EXPECTED_YARN_COMMAND_WORDS_210_22=([0]="yarn" [1]="unplug" [2]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_23=([0]="yarn" [1]="up" [2]="[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" [3]="[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" [4]="[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" [5]="[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" [6]="[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" [7]="[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret" [8]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_24=([0]="yarn" [1]="why" [2]="[-R|--recursive,--peers" [3]="[-R|--recursive,--peers" [4]="[-R|--recursive,--peers" [5]="<package")
        EXPECTED_YARN_COMMAND_WORDS_210_25=([0]="yarn" [1]="npm" [2]="login" [3]="[-s|--scope #0,--publish" [4]="[-s|--scope #0,--publish" [5]="[-s|--scope #0,--publish")
        EXPECTED_YARN_COMMAND_WORDS_210_26=([0]="yarn" [1]="npm" [2]="logout" [3]="[-s|--scope #0,--publish,-A|--all" [4]="[-s|--scope #0,--publish,-A|--all" [5]="[-s|--scope #0,--publish,-A|--all" [6]="[-s|--scope #0,--publish,-A|--all")
        EXPECTED_YARN_COMMAND_WORDS_210_27=([0]="yarn" [1]="npm" [2]="publish" [3]="[--access #0,--tag #0,--tolerate-republish" [4]="[--access #0,--tag #0,--tolerate-republish" [5]="[--access #0,--tag #0,--tolerate-republish" [6]="[--access #0,--tag #0,--tolerate-republish")
        EXPECTED_YARN_COMMAND_WORDS_210_28=([0]="yarn" [1]="npm" [2]="whoami" [3]="[-s|--scope #0,--publish" [4]="[-s|--scope #0,--publish" [5]="[-s|--scope #0,--publish")
        EXPECTED_YARN_COMMAND_WORDS_210_29=([0]="yarn" [1]="plugin" [2]="import" [3]="<name")
        EXPECTED_YARN_COMMAND_WORDS_210_30=([0]="yarn" [1]="plugin" [2]="import" [3]="from" [4]="sources" [5]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [6]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [7]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [8]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [9]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [10]="[--path #0,--repository #0,--branch #0,--no-minify,-f|--force" [11]="<name")
        EXPECTED_YARN_COMMAND_WORDS_210_31=([0]="yarn" [1]="plugin" [2]="list" [3]="[--json" [4]="[--json")
        EXPECTED_YARN_COMMAND_WORDS_210_32=([0]="yarn" [1]="plugin" [2]="remove" [3]="<name")
        EXPECTED_YARN_COMMAND_WORDS_210_33=([0]="yarn" [1]="plugin" [2]="runtime" [3]="[--json" [4]="[--json")
        EXPECTED_YARN_COMMAND_WORDS_210_34=([0]="yarn" [1]="workspace" [2]="<workspaceName" [3]="<commandName" [4]="...")
        EXPECTED_YARN_COMMAND_WORDS_210_35=([0]="yarn" [1]="workspaces" [2]="list" [3]="[-v|--verbose,--json" [4]="[-v|--verbose,--json" [5]="[-v|--verbose,--json")
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

    declare | grep Y2C_YARN_WORD_IS_TOKEN

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

@test "y2c_setup" {
    . lib.sh

    local is_y2c_failed=1

    y2c_generate_yarn_command_list() {
        :
    }

    y2c_generate_workspace_packages() {
        :
    }

    yarn() {
      run_mocked_yarn_command "$@"
    }

    cd test1
    y2c_detect_environment
    y2c_setup

    [ $Y2C_SETUP_HIT_CACHE -eq 0 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "2.4.2" ]
    [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx -eq 1 ]
    [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD}" ]
    [ $Y2C_IS_YARN_2_REPO -eq 1 ]

    cd ../test2

    y2c_setup || is_y2c_failed=0

    [ $is_y2c_failed ]
    [ $Y2C_SETUP_HIT_CACHE -eq 0 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "2.4.2" ]
    [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx -eq 1 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "1.22.10" ]
    [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy -eq 0 ]
    [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD}" ]
    [ $Y2C_IS_YARN_2_REPO -eq 0 ]

    cd ../test1/workspace-b
    y2c_setup

    [ $Y2C_SETUP_HIT_CACHE -eq 1 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "2.4.2" ]
    [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx -eq 1 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "1.22.10" ]
    [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy -eq 0 ]
    [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD%/workspace-b}" ]
    [ $Y2C_IS_YARN_2_REPO -eq 1 ]

    cd ../../test3/packages/workspace-a
    y2c_setup

    [ $Y2C_SETUP_HIT_CACHE -eq 0 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx == "2.4.2" ]
    [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx -eq 1 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy == "1.22.10" ]
    [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qy -eq 0 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz == "2.1.0" ]
    [ $Y2C_REPO_IS_YARN_2_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz -eq 1 ]
    [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD%/packages/workspace-a}" ]
    [ $Y2C_IS_YARN_2_REPO -eq 1 ]

}

@test "y2c_generate_yarn_command_list" {
    . lib.sh

    expand_yarn_workspace_command_list() {
        :
    }

    yarn() {
      run_mocked_yarn_command "$@"
    }

    cd test1
    y2c_detect_environment

    y2c_is_yarn_2
    y2c_generate_yarn_command_list "${Y2C_TMP_REPO_YARN_VERSION}"
    generate_yarn_expected_coomand_words "${Y2C_TMP_REPO_YARN_VERSION}"

    [ $YARN_COMMAND_WORDS_VER_Mi40LjI_ ]
    [ ! $YARN_COMMAND_WORDS_VER_Mi4xLjA_ ]
    validate_yarn_command_words "YARN_COMMAND_WORDS_VER_Mi40LjI_[@]" "EXPECTED_YARN_COMMAND_WORDS_242_" 43

    cd ../test3

    y2c_is_yarn_2
    y2c_generate_yarn_command_list "${Y2C_TMP_REPO_YARN_VERSION}"
    generate_yarn_expected_coomand_words "${Y2C_TMP_REPO_YARN_VERSION}"

    validate_yarn_command_words "YARN_COMMAND_WORDS_VER_Mi40LjI_[@]" "EXPECTED_YARN_COMMAND_WORDS_242_" 43
    validate_yarn_command_words "YARN_COMMAND_WORDS_VER_Mi4xLjA_[@]" "EXPECTED_YARN_COMMAND_WORDS_210_" 36
}

@test "set_package_name_path_map" {
    . lib.sh

    local package_names=()
    local package_paths=()

    yarn() {
      run_mocked_yarn_command "$@"
    }

    y2c_detect_environment

    package_names=("workspace-a" "workspace-b")
    package_paths=("/yarn-repo/packages/workspace-a" "/yarn-repo/packages/workspace-b")
    set_package_name_path_map "package_names[@]" "package_paths[@]"
    [ "$Y2C_PACKAGE_NAME_PATH_d29ya3NwYWNlLWE_" == "/yarn-repo/packages/workspace-a" ]
    [ "$Y2C_PACKAGE_NAME_PATH_d29ya3NwYWNlLWI_" == "/yarn-repo/packages/workspace-b" ]

    package_names=("@package1")
    package_paths=("/yarn-repo/packages/package-1")
    set_package_name_path_map "package_names[@]" "package_paths[@]"
    [ "$Y2C_PACKAGE_NAME_PATH_QHBhY2thZ2Ux" = "/yarn-repo/packages/package-1" ]
}

@test "y2c_generate_workspace_packages" {
    . lib.sh

    set_package_name_path_map() {
        :
    }

    y2c_detect_environment

    cd test1
    y2c_generate_workspace_packages "${PWD}"
    [ "${Y2C_WORKSPACE_PACKAGES_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qx[*]}" == "wrk-a wrk-b wrk-c" ]

    cd ../test3
    y2c_generate_workspace_packages "${PWD}"
    [ "${Y2C_WORKSPACE_PACKAGES_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3Qz[*]}" == "wrk-a wrk-b wrk-c" ]
 
}
