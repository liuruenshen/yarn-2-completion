#!/usr/bin/env sh

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

generate_yarn_expected_command_words() {
  version="$1"
  case "${version}" in
  2.4.2)
    cat <<"END"
    yarn	add	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	...")
    yarn	bin	[-v|--verbose,--json,name	[-v|--verbose,--json,name	[-v|--verbose,--json,name")
    yarn	cache	clean	[--mirror,--all	[--mirror,--all")
    yarn	config	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json")
    yarn	config	get	[--json,--no-redacted	[--json,--no-redacted	<name")
    yarn	config	set	[--json,-H|--home	[--json,-H|--home	<name	<value")
    yarn	dedupe	[-s|--strategy #0,-c|--check,--json	[-s|--strategy #0,-c|--check,--json	[-s|--strategy #0,-c|--check,--json	...")
    yarn	dlx	[-p|--package #0,-q|--quiet	[-p|--package #0,-q|--quiet	<command	...")
    yarn	exec	<commandName	...")
    yarn	explain	peer-requirements	[hash")
    yarn	info	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	...")
    yarn	init	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install")
    yarn	install	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds")
    yarn	link	[-A|--all,-p|--private,-r|--relative	[-A|--all,-p|--private,-r|--relative	[-A|--all,-p|--private,-r|--relative	<destination")
    yarn	node	...")
    yarn	npm	audit	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0")
    yarn	pack	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    yarn	patch	<package")
    yarn	patch-commit	<patchFolder")
    yarn	rebuild	...")
    yarn	remove	[-A|--all	...")
    yarn	run	[--inspect,--inspect-brk	[--inspect,--inspect-brk	<scriptName	...")
    yarn	set	resolution	[-s|--save	<descriptor	<resolution")
    yarn	set	version	[--only-if-needed	<version")
    yarn	set	version	from	sources	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    yarn	unplug	[-A|--all,-R|--recursive,--json	[-A|--all,-R|--recursive,--json	[-A|--all,-R|--recursive,--json	...")
    yarn	up	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	...")
    yarn	why	[-R|--recursive,--json,--peers	[-R|--recursive,--json,--peers	[-R|--recursive,--json,--peers	<package")
    yarn	npm	info	[-f|--fields #0,--json	[-f|--fields #0,--json	...")
    yarn	npm	login	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	npm	logout	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all")
    yarn	npm	publish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish")
    yarn	npm	tag	add	<package	<tag")
    yarn	npm	tag	list	[--json,package	[--json,package")
    yarn	npm	tag	remove	<package	<tag")
    yarn	npm	whoami	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	plugin	import	<name")
    yarn	plugin	import	from	sources	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	<name")
    yarn	plugin	list	[--json")
    yarn	plugin	remove	<name")
    yarn	plugin	runtime	[--json")
    yarn	workspace	<workspaceName	<commandName	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	<commandName	...")
    yarn	workspaces	list	[-v|--verbose,--json	[-v|--verbose,--json")
    yarn	<scriptName")
END
    ;;
  2.1.0)
    cat <<"END"
    yarn	add	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	...")
    yarn	bin	[-v|--verbose,--json,name	[-v|--verbose,--json,name	[-v|--verbose,--json,name")
    yarn	cache	clean	[--mirror,--all	[--mirror,--all")
    yarn	config	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json")
    yarn	config	get	[--json,--no-redacted	[--json,--no-redacted	<name")
    yarn	config	set	[--json	<name	<value")
    yarn	dlx	[-p|--package #0,-q|--quiet	[-p|--package #0,-q|--quiet	<command	...")
    yarn	exec	<commandName	...")
    yarn	init	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install")
    yarn	install	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds")
    yarn	link	[--all,-p|--private,-r|--relative	[--all,-p|--private,-r|--relative	[--all,-p|--private,-r|--relative	<destination")
    yarn	node	...")
    yarn	npm	info	[-f|--fields #0,--json	[-f|--fields #0,--json	...")
    yarn	pack	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    yarn	patch	<package")
    yarn	patch-commit	<patchFolder")
    yarn	rebuild	...")
    yarn	remove	[-A|--all	...")
    yarn	run	[--inspect,--inspect-brk	[--inspect,--inspect-brk	<scriptName	...")
    yarn	set	resolution	[-s|--save	<descriptor	<resolution")
    yarn	set	version	[--only-if-needed	<version")
    yarn	set	version	from	sources	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    yarn	unplug	...")
    yarn	up	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	...")
    yarn	why	[-R|--recursive,--peers	[-R|--recursive,--peers	<package")
    yarn	npm	login	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	npm	logout	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all")
    yarn	npm	publish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish")
    yarn	npm	whoami	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	plugin	import	<name")
    yarn	plugin	import	from	sources	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	<name")
    yarn	plugin	list	[--json")
    yarn	plugin	remove	<name")
    yarn	plugin	runtime	[--json")
    yarn	workspace	<workspaceName	<commandName	...")
    yarn	workspaces	list	[-v|--verbose,--json	[-v|--verbose,--json")
    yarn	<scriptName")
END
    ;;
  esac
}

generate_expected_workspace_commands() {
  version="$1"
  case "${version}" in
  2.4.2)
    cat <<"END"
    yarn	workspace	<workspaceName	add	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	...")
    yarn	workspace	<workspaceName	bin	[-v|--verbose,--json,name	[-v|--verbose,--json,name	[-v|--verbose,--json,name")
    yarn	workspace	<workspaceName	cache	clean	[--mirror,--all	[--mirror,--all")
    yarn	workspace	<workspaceName	config	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json")
    yarn	workspace	<workspaceName	config	get	[--json,--no-redacted	[--json,--no-redacted	<name")
    yarn	workspace	<workspaceName	config	set	[--json,-H|--home	[--json,-H|--home	<name	<value")
    yarn	workspace	<workspaceName	dedupe	[-s|--strategy #0,-c|--check,--json	[-s|--strategy #0,-c|--check,--json	[-s|--strategy #0,-c|--check,--json	...")
    yarn	workspace	<workspaceName	dlx	[-p|--package #0,-q|--quiet	[-p|--package #0,-q|--quiet	<command	...")
    yarn	workspace	<workspaceName	exec	<commandName	...")
    yarn	workspace	<workspaceName	explain	peer-requirements	[hash")
    yarn	workspace	<workspaceName	info	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	...")
    yarn	workspace	<workspaceName	init	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install")
    yarn	workspace	<workspaceName	install	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds")
    yarn	workspace	<workspaceName	link	[-A|--all,-p|--private,-r|--relative	[-A|--all,-p|--private,-r|--relative	[-A|--all,-p|--private,-r|--relative	<destination")
    yarn	workspace	<workspaceName	node	...")
    yarn	workspace	<workspaceName	npm	audit	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0")
    yarn	workspace	<workspaceName	pack	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    yarn	workspace	<workspaceName	patch	<package")
    yarn	workspace	<workspaceName	patch-commit	<patchFolder")
    yarn	workspace	<workspaceName	rebuild	...")
    yarn	workspace	<workspaceName	remove	[-A|--all	...")
    yarn	workspace	<workspaceName	run	[--inspect,--inspect-brk	[--inspect,--inspect-brk	<scriptName	...")
    yarn	workspace	<workspaceName	set	resolution	[-s|--save	<descriptor	<resolution")
    yarn	workspace	<workspaceName	set	version	[--only-if-needed	<version")
    yarn	workspace	<workspaceName	set	version	from	sources	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    yarn	workspace	<workspaceName	unplug	[-A|--all,-R|--recursive,--json	[-A|--all,-R|--recursive,--json	[-A|--all,-R|--recursive,--json	...")
    yarn	workspace	<workspaceName	up	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	...")
    yarn	workspace	<workspaceName	why	[-R|--recursive,--json,--peers	[-R|--recursive,--json,--peers	[-R|--recursive,--json,--peers	<package")
    yarn	workspace	<workspaceName	npm	info	[-f|--fields #0,--json	[-f|--fields #0,--json	...")
    yarn	workspace	<workspaceName	npm	login	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	workspace	<workspaceName	npm	logout	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all")
    yarn	workspace	<workspaceName	npm	publish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish")
    yarn	workspace	<workspaceName	npm	tag	add	<package	<tag")
    yarn	workspace	<workspaceName	npm	tag	list	[--json,package	[--json,package")
    yarn	workspace	<workspaceName	npm	tag	remove	<package	<tag")
    yarn	workspace	<workspaceName	npm	whoami	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	workspace	<workspaceName	plugin	import	<name")
    yarn	workspace	<workspaceName	plugin	import	from	sources	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	<name")
    yarn	workspace	<workspaceName	plugin	list	[--json")
    yarn	workspace	<workspaceName	plugin	remove	<name")
    yarn	workspace	<workspaceName	plugin	runtime	[--json")
    yarn	workspace	<workspaceName	<scriptName")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	add	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	bin	[-v|--verbose,--json,name	[-v|--verbose,--json,name	[-v|--verbose,--json,name")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	cache	clean	[--mirror,--all	[--mirror,--all")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	config	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	config	get	[--json,--no-redacted	[--json,--no-redacted	<name")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	config	set	[--json,-H|--home	[--json,-H|--home	<name	<value")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	dedupe	[-s|--strategy #0,-c|--check,--json	[-s|--strategy #0,-c|--check,--json	[-s|--strategy #0,-c|--check,--json	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	dlx	[-p|--package #0,-q|--quiet	[-p|--package #0,-q|--quiet	<command	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	exec	<commandName	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	explain	peer-requirements	[hash")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	info	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	[-A|--all,-R|--recursive,-X|--extra #0,--cache,--dependents,--manifest,--name-only,--virtuals,--json	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	init	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	install	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds,--skip-builds")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	link	[-A|--all,-p|--private,-r|--relative	[-A|--all,-p|--private,-r|--relative	[-A|--all,-p|--private,-r|--relative	<destination")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	node	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	audit	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0	[-A|--all,-R|--recursive,--environment #0,--json,--severity #0")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	pack	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	patch	<package")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	patch-commit	<patchFolder")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	rebuild	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	remove	[-A|--all	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	run	[--inspect,--inspect-brk	[--inspect,--inspect-brk	<scriptName	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	set	resolution	[-s|--save	<descriptor	<resolution")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	set	version	[--only-if-needed	<version")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	set	version	from	sources	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	unplug	[-A|--all,-R|--recursive,--json	[-A|--all,-R|--recursive,--json	[-A|--all,-R|--recursive,--json	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	up	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-E|--exact,-T|--tilde,-C|--caret	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	why	[-R|--recursive,--json,--peers	[-R|--recursive,--json,--peers	[-R|--recursive,--json,--peers	<package")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	info	[-f|--fields #0,--json	[-f|--fields #0,--json	...")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	login	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	logout	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	publish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	tag	add	<package	<tag")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	tag	list	[--json,package	[--json,package")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	tag	remove	<package	<tag")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	npm	whoami	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	plugin	import	<name")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	plugin	import	from	sources	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	<name")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	plugin	list	[--json")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	plugin	remove	<name")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	plugin	runtime	[--json")
    yarn	workspaces	foreach	[-A|--all,-j|--jobs #0	[-A|--all,-j|--jobs #0	<scriptName")
END
    ;;
  2.1.0)
    cat <<"END"
    yarn	workspace	<workspaceName	add	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached	...")
    yarn	workspace	<workspaceName	bin	[-v|--verbose,--json,name	[-v|--verbose,--json,name	[-v|--verbose,--json,name")
    yarn	workspace	<workspaceName	cache	clean	[--mirror,--all	[--mirror,--all")
    yarn	workspace	<workspaceName	config	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json	[-v|--verbose,--why,--json")
    yarn	workspace	<workspaceName	config	get	[--json,--no-redacted	[--json,--no-redacted	<name")
    yarn	workspace	<workspaceName	config	set	[--json	<name	<value")
    yarn	workspace	<workspaceName	dlx	[-p|--package #0,-q|--quiet	[-p|--package #0,-q|--quiet	<command	...")
    yarn	workspace	<workspaceName	exec	<commandName	...")
    yarn	workspace	<workspaceName	init	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install	[-p|--private,-w|--workspace,-i|--install")
    yarn	workspace	<workspaceName	install	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds	[--json,--immutable,--immutable-cache,--check-cache,--inline-builds")
    yarn	workspace	<workspaceName	link	[--all,-p|--private,-r|--relative	[--all,-p|--private,-r|--relative	[--all,-p|--private,-r|--relative	<destination")
    yarn	workspace	<workspaceName	node	...")
    yarn	workspace	<workspaceName	npm	info	[-f|--fields #0,--json	[-f|--fields #0,--json	...")
    yarn	workspace	<workspaceName	pack	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0	[--install-if-needed,-n|--dry-run,--json,-o|--out #0,--filename #0")
    yarn	workspace	<workspaceName	patch	<package")
    yarn	workspace	<workspaceName	patch-commit	<patchFolder")
    yarn	workspace	<workspaceName	rebuild	...")
    yarn	workspace	<workspaceName	remove	[-A|--all	...")
    yarn	workspace	<workspaceName	run	[--inspect,--inspect-brk	[--inspect,--inspect-brk	<scriptName	...")
    yarn	workspace	<workspaceName	set	resolution	[-s|--save	<descriptor	<resolution")
    yarn	workspace	<workspaceName	set	version	[--only-if-needed	<version")
    yarn	workspace	<workspaceName	set	version	from	sources	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--plugin #0,--no-minify,-f|--force")
    yarn	workspace	<workspaceName	unplug	...")
    yarn	workspace	<workspaceName	up	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	[-i|--interactive,-v|--verbose,-E|--exact,-T|--tilde,-C|--caret	...")
    yarn	workspace	<workspaceName	why	[-R|--recursive,--peers	[-R|--recursive,--peers	<package")
    yarn	workspace	<workspaceName	npm	login	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	workspace	<workspaceName	npm	logout	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all	[-s|--scope #0,--publish,-A|--all")
    yarn	workspace	<workspaceName	npm	publish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish	[--access #0,--tag #0,--tolerate-republish")
    yarn	workspace	<workspaceName	npm	whoami	[-s|--scope #0,--publish	[-s|--scope #0,--publish")
    yarn	workspace	<workspaceName	plugin	import	<name")
    yarn	workspace	<workspaceName	plugin	import	from	sources	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	[--path #0,--repository #0,--branch #0,--no-minify,-f|--force	<name")
    yarn	workspace	<workspaceName	plugin	list	[--json")
    yarn	workspace	<workspaceName	plugin	remove	<name")
    yarn	workspace	<workspaceName	plugin	runtime	[--json")
    yarn	workspace	<workspaceName	<scriptName")
END
    ;;
  esac
}

# The native "yarn --version" command is a bit slow, so this function is a workaround
# to get the yarn version faster for accelerating the testing.
yarn_get_version_from_yarnrc() {
  yarn_version=""
  inspected_path="${PWD}"

  while [ "${inspected_path}" ]; do
    if [ -f "${inspected_path}/.yarnrc.yml" ]; then
      yarn_version=$(grep yarnPath "${inspected_path}/.yarnrc.yml")
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

run_mocked_yarn_command() {
  if [ "$1" = '--help' ]; then
    yarn_help_mock
  elif [ "$1" = '--version' ]; then
    yarn_get_version_from_yarnrc
  else
    @yarn "$@"
  fi
}
