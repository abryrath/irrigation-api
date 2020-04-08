const execa = require('execa');
const colors = require('colors/safe');
const args = require('args');
const deployments = require('./config');

const getDeploymentByBranchName = branch => {
  return deployments.find(deployment => deployment.branch == branch);
};

const getGitBranch = async () => {
  const result = await execa.command('git branch --show-current');
  if (result.exitCode === 0) {
    return result.stdout;
  }
  return '';
};

const getGitHead = async () => {
    const result = await execa.command('git rev-parse HEAD');
    if (result.exitCode === 0) {
        return result.stdout;
    }
    return '';
};

const getDeployCommands = (branch, head) => {
  try {
    const config = getDeploymentByBranchName(branch);
    config.gitHead = head;
    const cmdArray = parseCommands(config);
    return cmdArray.reverse();
  } catch (e) {
    console.log(colors.yellow(`No deployments configured for ${branch}`));
    console.error(e);
    return [];
  }
};

/** @return string */
const parseCommands = config => {
  const { sshCommand, commandPrefix } = config;
  return config.commands.map(curr => {
    return parseSshCommand(`${sshCommand} "${commandPrefix} ${curr}"`, config);
  });
};

const parseSshCommand = (cmd, config) => {
  return cmd
    .replace(/{{gitCommand}}/g, config.gitCommand)
    .replace(/{{mixCommand}}/g, config.mixCommand)
    .replace(/{{commands}}/g, config.commandsString)
    .replace(/{{user}}/g, config.user)
    .replace(/{{host}}/g, config.host)
    .replace(/{{branch}}/g, config.branch)
    .replace(/{{yarnCommand}}/g, config.yarnCommand)
    .replace(/{{composerCommand}}/g, config.composerCommand)
    .replace(/{{craftCommand}}/g, config.craftCommand)
    .replace(/{{gitHead}}/g, config.gitHead)
    .replace(/{{rootDir}}/g, config.rootDir);
};

const deploy = async cmds => {
  if (cmds.length === 0) {
    return 0;
  }

  const cmd = cmds.pop();
  console.log(colors.yellow('> '), colors.green(cmd));
  const result = await execa.command(cmd);
  if (result.exitCode === 0) {
    console.log(colors.green(result.stdout));
  } else {
    console.log(colors.red(result.stderr));
    return 1;
  }
  return deploy(cmds);
};

const main = async (flags) => {
  let branch;
  if (flags.branch === 'auto') {
    branch = await getGitBranch();
  } else {
    branch = flags.branch.trim();
  }
  const head = await getGitHead();

  console.log(colors.grey('Using commit: '), head);

  const deployCommands = getDeployCommands(branch, head);
  if (!deployCommands.length) {
    return 1;
  }
  const result = await deploy(deployCommands);
  return result;
};

args.option('branch', 'The branch to deploy', 'auto');
const flags = args.parse(process.argv);
main(flags);
