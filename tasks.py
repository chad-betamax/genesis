import os
from pathlib import Path
import shutil
import itertools
from invoke import task

@task
def psql(ctx):
    """
    DBmate runs locally and requires the version of the postgres client tools to be
    in-sync with the version of postgres you're using on the container. The default
    Ubuntu repos have an older version; therefore we have to do some shenanigans and add
    this repo in so a later apt-get will install the version want (ie that is in syc
    with the posgres version used on the container)
    """
    repo = 'http://apt.postgresql.org/pub/repos/apt'
    aptpath = '/etc/apt/sources.list.d/pgdg.list'
    ctx.run(f'sudo sh -c \'echo "deb {repo} $(lsb_release -cs)-pgdg main">{aptpath}\'')

    url = 'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
    ctx.run(f'wget --quiet -O - {url} | sudo apt-key add -')  # failing here, need to
    # swap out the apt-key see:
    # https://askubuntu.com/questions/1286545/what-commands-exactly-should-replace-the-deprecated-apt-key
    # also this may be useful:
    # https://github.com/ameinild/add-apt-key
    ctx.run('sudo apt-get update')


# @task(psql)
@task()
def binaries(ctx):
    """
    install tools with your package manager

    tools that you're happy to install with a package manager, implying we don't care
    too much about version etc (as we would if it were (say) pip)
    for the moment we use apt-get, could add homebrew etc
    """
    print('\nrunning binaries')
    tools = {
        'misc_tools': ['direnv', 'bat', 'htop', 'silversearcher-ag', 'pwgen', 'cloc', ],
        'web_tools': ['curl', 'httpie', 'jq',],
        # 'DB_tools': ['postgresql-client-14'],
        'edit_tools': ['tmux', 'vim', 'topydo',],
        'dependencies': ['python3-libtmux', 'entr', 'xsel'],
        'config_tools': ['vcsh', 'myrepos',],
        'container_tools': ['podman', 'crun', 'slirp4netns',]
    }
    alltools = list(itertools.chain.from_iterable(tools.values()))
    ctx.run(f"sudo apt-get install -y {' '.join(alltools)}")

    # DBmate not available with apt...
    installpath = '/usr/local/bin/dbmate'
    if not Path(installpath).is_file():
        url = 'https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64'
        ctx.run(f'sudo curl -fsSL -o {installpath} {url}')


# where most configs live
conf = f'{Path.home()}/.config'

@task
def prep(ctx):
    """
    some initial setup, to prep our box
    """
    # make dirs for vcsh
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

    """
    git needs some of these vars to run (on a fresh box)... which means we are keeping
    git config here rather than tracking it with vcsh/mr
    """
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
        avail = f"{conf}/myrepos/available.d"
        enbl = f"{conf}/myrepos/enabled.d"
        # at the moment we're enabling all of em
        for app in os.listdir(avail):
            ctx.run(f"ln --symbolic {avail}/{app} {enbl}/{app}")
    else:
        print('myrepos already tracked... skip to updating the other repos')

    # and use mr to suck down the config files
    ctx.run('mr update')  # implicitly does a checkout if needed

@task()
def plugins(ctx):
    """
    install the various plugins for vim and tmux
    (both use plugin managers; vundle and tpm respectively)
    """
    # Vim
    print('\ninstalling vim plugins')
    ctx.run('vim +PluginInstall +qall')

    # Tmux
    print('\ninstalling tmux plugin manager')
    tpm = Path.home()/'.tmux/plugins/tpm'
    if not tpm.is_dir():
        ctx.run(f'git clone https://github.com/tmux-plugins/tpm {tpm}')
        ctx.run(f'{tpm}/bin/install_plugins')
    else:
        print('looks like tmux plugin manager already installed')
        ctx.run(f'{tpm}/bin/install_plugins')


@task()
def firefox(ctx):
    # make dir where firefox add-ons will live
    moz = f'{Path.home()}/.mozilla/extensions'
    Path(moz).mkdir(parents=True, exist_ok=True)
    os.chmod(moz, 0o775)

    root = 'https://addons.mozilla.org/firefox/downloads/file'
    stems = {
        '3878852': 'startpage_privacy_protection-1.0.0-fx.xpi',
        '3933192': 'ublock_origin-1.42.4-an+fx.xpi'
    }
    for num,name in stems.items():
        if not Path(f'{moz}/{name}').is_file():
            ctx.run(f'curl -fsSL -o {moz}/{name} {root}/{num}/{name}')
    # TODO: get firefox to pick up these add-ons automatically
    # at the moment have use "Install add-on from file" from inside Firefox


@task()
def mate(ctx):
    """
    if you're using a Mate desktop
    then apply these settings using dconf
    """
    if os.environ.get('XDG_CURRENT_DESKTOP') == 'MATE':
        ctx.run('dconf load / <~/.config/mate/mate-settings')


@task(binaries, configs, plugins, mate)
def genesis(ctx):
    sunnies = '😎️'
    print(f'All done!  {sunnies *3}')
