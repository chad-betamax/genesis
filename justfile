mod apt "modules/apt.just"
mod curl "modules/curl.just"
mod dra "modules/dra.just"


default:
    @just --list

apt-installs: 
    # Initialise apt
    @apt update
    @apt autoremove

    @just apt::get "git"
    @just apt::get "tmux"
    @just apt::get "traceroute"
    @just apt::get "xclip"
    @just apt::get "nmap"
    @just apt::get "htop"
    @just apt::get "members"
    @just apt::get "keychain"
    @just apt::get "jq"
    @just apt::get "direnv"
    @just apt::get "tree"
    @just apt::get "openssh-server"

dradeb := "dra_0.7.0-1_amd64.deb"
curl-installs:
    # Installing dra
    @just curl::download "https://github.com/devmatteini/dra/releases/download/0.7.0/{{ dradeb }}"
    @sudo dpkg -i /tmp/{{ dradeb }}


dra-installs:
    # Dra installs

    # dra can't install neovim as it creates dirs, use as a downloader only
    @just dra::download "neovim/neovim"
    # tar extract into /opt
    @sudo tar --directory /opt -xzf /tmp/nvim*.tar.gz

    # rg, a faster grep
    @just dra::install "BurntSushi/ripgrep" 

    # bat, cat with syntax highlighting
    @just dra::install "sharkdp/bat"

    # delta, syntax highlighting for git, diff and grep output 
    @just dra::install "dandavison/delta" 

    #faster find
    @just dra::install "sharkdp/fd"

    # deploy config dotfiles
    @just dra::install "twpayne/chezmoi" 
    @sudo mv /usr/local/bin/chezmoi* /usr/local/bin/chezmoi 

# Install all the things
deploy: apt-installs curl-installs dra-installs

