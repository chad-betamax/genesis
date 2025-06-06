mod apt "modules/apt.just"
mod dra "modules/dra.just"



_paths :="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
[group('install')]
_tidypath:
    @echo 'PATH="{{ _paths }}"' | sudo tee /etc/environment > /dev/null


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

_dra := "https://raw.githubusercontent.com/devmatteini/dra/refs/heads/main/install.sh"
_rust := "https://sh.rustup.rs"
_aws := "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
_uv := "https://astral.sh/uv/install.sh"


[group('install')]
curl-installs:
    # Curl installs
    # #############################################

    # Install rust
    @curl --proto '=https' --tlsv1.2 {{ _rust }} --silent --show-error --fail|sh -s -- -y --no-modify-path

    # Install dra (a Github downloader)
    @curl --proto '=https' --tlsv1.2 --silent --show-error --fail {{ _dra }} | sudo bash -s -- --to /usr/local/bin/

    # Install AWS CLI
    @curl --proto '=https' --tlsv1.2 --silent --show-error --fail {{ _aws }} -o "/tmp/awscliv2.zip"
    @unzip -q /tmp/awscliv2.zip -d /tmp
    @cd /tmp; sudo ./aws/install || cd /tmp; sudo ./aws/install --update
    # cleanup
    @rm /tmp/awscliv2.zip; rm -r /tmp/aws

    # Install uv the python package manager
    @curl --proto '=https' --tlsv1.2 --location --silent --show-error {{ _uv }} | sh

[group('install')]
git-installs:
    #!/usr/bin/env sh
    # if already installed do nothing 
    META={{executable_directory()}}/metatools
    if [ ! -d $META ]; then
        cd {{executable_directory()}}
        git clone https://github.com/chad-betamax/metatools.git 
    fi


[group('install')]
dra-installs:
    # Dra installs
    # #############################################

    # rage encryption, used by chezmoi
    @just dra::multi "str4d/rage" "rage rage-keygen rage-mount"

    # chezmoi a dotfile manager
    @just dra::install "twpayne/chezmoi" 

    # dra can't install neovim as it creates dirs, use as a downloader only
    @just dra::download "neovim/neovim"
    # tar extract into /opt
    @sudo tar --directory /opt -xzf /tmp/nvim*.tar.gz

    # rg, a faster grep
    @just dra::install "BurntSushi/ripgrep" 

    # bat, cat with syntax highlighting
    @just dra::install "sharkdp/bat"

    #faster find
    @just dra::install "sharkdp/fd"

    # delta, syntax highlighting for git, diff and grep output 
    @just dra::install "dandavison/delta" 

    # interact with Github with a cli 
    @just dra::install "cli/cli"

    # minimap render used by neovim plugin
    @just dra::install "wfxr/code-minimap"

    # ruff, python linter/formatter
    @just dra::install "astral-sh/ruff"

    # a cli snapshot manager
    #@just dra::install "kimono-koans/httm"

    ## a to-do list 
    #@just dra::install Fanteria/todotxt-tui




