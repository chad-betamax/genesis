mod apt "../modules/apt.just"

[group('install')]
apt-installs:
    # Apt installs
    # #############################################

    @just apt::initialise

    @just apt::get "git"
    @just apt::get "tmux"
    @just apt::get "traceroute"
    @just apt::get "xclip"
    @just apt::get "nmap"
    @just apt::get "htop"
    @just apt::get "members"
    @just apt::get "jq"
    @just apt::get "direnv"
    @just apt::get "tree"
    @just apt::get "openssh-server"
    @just apt::get "pwgen"
    @just apt::get "build-essential"

    #@just apt::get "keychain"

