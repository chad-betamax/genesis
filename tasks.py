import os
from pathlib import Path
import shutil
import itertools
from invoke import task

tools = {
    'misc_tools': ['direnv', 'bat', 'htop', 'silversearcher-ag', 'pwgen', 'cloc', ],
    'web_tools': ['curl', 'httpie', 'jq',],
    'edit_tools': ['tmux', 'vim', 'topydo',],
    'config_tools': ['vcsh', 'myrepos',],
    'container_tools': ['podman', 'crun', 'slirp4netns',]
}



@task
def binaries(ctx):
    alltools = list(itertools.chain.from_iterable(tools.values()))
    ctx.run(f"sudo apt-get install -y {' '.join(alltools)}")


@task
def configs(ctx):
    # make dirs for firefox and vcsh if needed
    hook = '.config/vcsh/hooks-enabled'
    fox = '.mozilla/firefox'
    Path(f'{Path.home()}/{fox}').mkdir(parents=True, exist_ok=True)
    Path(f'{Path.home()}/{hook}').mkdir(parents=True, exist_ok=True)

    # this will create vcsh dirs needed
    ctx.run("vcsh list >/dev/null")

    # place the git hook script used by vcsh
    src = Path('pre-merge-unclobber').resolve()
    dest = Path(f'{Path.home()}/{hook}/pre-merge-unclobber')
    shutil.copyfile(src, dest)

    # some git configs
    commit_name = 'Doug'
    commit_email = 'doug@phoenox.net'
    fmt = '%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
    flags = '--all --color --graph --abbrev-commit'

    ctx.run("git config --global init.defaultBranch main")
    ctx.run(f"git config --global user.name {commit_name}")
    ctx.run(f"git config --global user.email {commit_email}")
    ctx.run(f'git config --global alias.tree "log {flags} --pretty=format:{fmt}"')


@task
def myrepos(ctx):
    """
    use vcsh to suck down the config for myrepos
    then run myrepos
    myrepos will then in turn use vcsh to suck down the configs for the various tools
    where you are the version controling their configs
    """
    repo = 'git@github.com:chad-betamax/configs.git'
    myr = f"{Path.home()}/.config/myrepos"
    avail = f"{myr}/available.d"
    enabled = f"{myr}/enabled.dr"
    ctx.run(f'vcsh clone --branch mr {repo} mr')
    Path(f"{enabled}").mkdir(parents=True, exist_ok=True)
    for app in os.listdir(avail):
        ctx.run(f"ln --symbolic {avail}/{app} {enabled}/{app}")

    #make sure we're in ~
    os.chdir(Path.home())
    ctx.run('mr checkout')


# .PHONY: mr
# mr:
	# @vcsh clone -b mr $(CONFIGSREPO) mr
	# @if test ! -d $(ENBL); then mkdir $(ENBL); fi
	# @cd $(ENBL); for i in $(ls $(AVAIL)/|grep -v mr.vcsh); \
		# do ln -s $(AVAIL)/$i; done

# .PHONY: repos
# repos:
	# @cd ~; mr checkout

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
