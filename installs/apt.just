mod apt "../modules/apt.just"


[group('apt')]
_initialise:
    @just apt::initialise

[group('apt')]
git-install:
    @just apt::get "git"

[group('apt')]
tmux-install:
    @just apt::get "tmux"

[group('apt')]
traceroute-install:
    @just apt::get "traceroute"

[group('apt')]
xclip-install:
    @just apt::get "xclip"

[group('apt')]
nmap-install:
    @just apt::get "nmap"

[group('apt')]
htop-install:
    @just apt::get "htop"

[group('apt')]
members-install:
    @just apt::get "members"

[group('apt')]
jq-install:
    @just apt::get "jq"

[group('apt')]
direnv-install:
    @just apt::get "direnv"

[group('apt')]
tree-installl:
    @just apt::get "tree"

[group('apt')]
openssh-server-install:
    @just apt::get "openssh-server"
    
[group('apt')]
pwgen-install:
    @just apt::get "pwgen"

[group('apt')]
build-essential-install:
    @just apt::get "build-essential"

[group('install')]
apt-install: _initialise git-install tmux-install traceroute-install xclip-install nmap-install htop-install members-install jq-install direnv-install tree-installl openssh-server-install pwgen-install build-essential-install
    
