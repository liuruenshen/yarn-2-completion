// https://classic.yarnpkg.com/blog/2018/02/15/nohoist/
function main() {
  if (process.argv.length !== 3) {
    process.exitCode = 1;
    return ''
  }

  try {
    const packageConfig = require(process.argv[2]);
    if (typeof packageConfig !== 'object') {
      process.exitCode = 2;
      return ''
    }
    if (Array.isArray(packageConfig.workspaces)) {
      return packageConfig.workspaces.join(' ')
    }
    if (packageConfig.workspaces && Array.isArray(packageConfig.workspaces.packages)) {
      return packageConfig.workspaces.packages.join(' ')
    }
    process.exitCode = 3;
    return ''
  }
  catch (e) {
    process.exitCode = 4;
    return ''
  }
}

console.log(main())