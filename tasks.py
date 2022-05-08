import os
from pathlib import Path
import shutil
import itertools
from invoke import task




@task
def binaries(ctx):
    """
    install tools with your package manager

    tools that you're happy to install with a package manager, implying we don't carte
    too much about version etc (as we would if it were (say) pip)
    for the moment we use apt-get, could add homebrew etc
    """
    print('\nrunning binaries')
    tools = {
        'misc_tools': ['direnv', 'bat', 'htop', 'silversearcher-ag', 'pwgen', 'cloc', ],
        'web_tools': ['curl', 'httpie', 'jq',],
        'edit_tools': ['tmux', 'vim', 'topydo',],
        'config_tools': ['vcsh', 'myrepos',],
        'container_tools': ['podman', 'crun', 'slirp4netns',]
    }
    alltools = list(itertools.chain.from_iterable(tools.values()))
    ctx.run(f"sudo apt-get install -y {' '.join(alltools)}")

# where most configs live
conf = f'{Path.home()}/.config'

@task
def prep(ctx):
    """
    some initial setup, to prep our box
    """
    print('\nrunning prep')
    # make dirs for firefox
    Path(f'{Path.home()}/.mozilla/firefox').mkdir(parents=True, exist_ok=True)
    # and vcsh
    Path(f'{conf}/vcsh/repo.d').mkdir(parents=True, exist_ok=True)
    Path(f'{conf}/vcsh/hooks-enabled').mkdir(parents=True, exist_ok=True)
    # and myrepos
    Path(f'{conf}/myrepos/available.d').mkdir(parents=True, exist_ok=True)
    Path(f'{conf}/myrepos/enabled.d').mkdir(parents=True, exist_ok=True)
    # place the git hook script used by vcsh
    src = Path('pre-merge-unclobber').resolve()
    dest = Path(f'{conf}/vcsh/hooks-enabled/pre-merge-unclobber')
    shutil.copyfile(src, dest)
    os.chmod(dest, 0o775)

    # some git configs
    commit_name = 'Doug'
    commit_email = 'doug@phoenox.net'
    git_ssh = 'ssh -i ~/.ssh/id_github -o StrictHostKeyChecking=no -o IdentitiesOnly=yes'
    fmt = '%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
    flags = '--all --color --graph --abbrev-commit'

    ctx.run('git config --global init.defaultBranch main')
    ctx.run(f'git config --global user.name {commit_name}')
    ctx.run(f'git config --global user.email {commit_email}')
    ctx.run(f'git config --global core.sshCommand "{git_ssh}"')
    ctx.run(f'git config --global alias.tree "log {flags} --pretty=format:{fmt}"')


@task(prep)
def configs(ctx):
    """
    deploy config files for your favourite tools

    use vcsh to suck down the config for myrepos
    then run myrepos
    myrepos will then in turn use vcsh to suck down the configs for the various tools
    which are version controlled (the config is version controlled that is)
    """
    print('\nrunning configs')

    #make sure we're in ~
    os.chdir(Path.home())

    repo = Path(f"{conf}/vcsh/repo.d/mr.git")
    if not repo.is_dir():
        origin = 'git@github.com:chad-betamax/configs.git'

        # use vcsh to deploy the config for myrepos
        # (vcsh doesn't allow --branch or --quiet)
        sshkey = '~/.ssh/id_github'
        flags = '-oStrictHostKeyChecking=no -oIdentitiesOnly=yes'
        ctx.run(f'GIT_SSH_COMMAND="ssh -i {sshkey} {flags}" vcsh clone -b mr {origin} mr')

        # that sets up mr so it now knows what tools are available for tracking
        # at the moment we're enabling all of em
        avail = f"{conf}/myrepos/available.d"
        enbl = f"{conf}/myrepos/enabled.d"
        for app in os.listdir(avail):
            ctx.run(f"ln --symbolic {avail}/{app} {enbl}/{app}")

        # and use mr to suck down the config files
        ctx.run('mr checkout')

    else:
        print('myrepos already tracked .. exiting')


@task(binaries, configs)
def genesis(ctx):
    print("All done!")


# .PHONY: mate
# mate:
	# @if test -f ~/mate-settings; then dconf load / <~/mate-settings; rm ~/mate-settings; fi

# .PHONY: tmux
# tmux:
	# @git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# .PHONY: vim
# vim:
	# @vim +PluginInstall +qall

# box: install configs mr repos mate tmux vim
