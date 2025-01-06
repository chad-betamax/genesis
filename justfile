mod apt "modules/apt.just"
mod dra "modules/dra.just"


_default:
    @just --list

_paths :="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
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
    @just apt::get "keychain"
    @just apt::get "jq"
    @just apt::get "direnv"
    @just apt::get "tree"
    @just apt::get "openssh-server"
    @just apt::get "sshfs"

_dra := "https://github.com/devmatteini/dra/releases/download/0.7.0/dra_0.7.0-1_amd64.deb"
_rust := "https://sh.rustup.rs"
[group('install')]
curl-installs:
    # Curl installs
    # #############################################

    # Install rust
    @curl --proto '=https' --tlsv1.2 {{ _rust }} --silent --show-error --fail|sh -s -- -y --no-modify-path

    # Install dra
    @curl --silent --show-error --location {{ _dra }} --output-dir /tmp --output dra.deb
    @sudo dpkg --install /tmp/dra.deb

[group('install')]
git-installs:
    #!/usr/bin/env sh
    META={{executable_directory()}}/metatools
    if [ -d $META ]
    then
        cd $META; git checkout . ; git pull
    else
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
    @sudo rm /usr/local/bin/chezmoi* 2>/dev/null
    @just dra::install "twpayne/chezmoi" 
    @sudo mv /usr/local/bin/chezmoi* /usr/local/bin/chezmoi 

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


# Install all the things
[group('install')]
install: _tidypath apt-installs curl-installs dra-installs




[group('config')]
_dotfiles:
    @printf 'deploying dotfiles...\n'
    @chezmoi init --apply --verbose https://github.com/chad-betamax/dotfiles.git
    @printf 'dotfile config done\n\n'

[group('config')]
_tmux:                                                                                         
    #!/usr/bin/env sh
    MAN={{config_directory()}}/tmux/plugins/tpm
    if [ -d $MAN ]
    then
        printf "tpm already installed; doing updates...\n"
        $MAN/bin/clean_plugins
        $MAN/bin/update_plugins all
        # needed to catch new plugins 
        $MAN/bin/install_plugins
        printf "\n"
    else
        printf "installing tmux plugins"
        mkdir -p $MAN
        git clone https://github.com/tmux-plugins/tpm $MAN && $MAN/bin/install_plugins
    fi                                                                                                                  
            

[group('config')]
_neovim:
    @printf "neovim plugins\n"



[group('config')]
_plugins: _tmux _neovim
    @echo 'all done with plugins...'

# deploy dotfiles and plugins for all your programs
[group('config')]
config: _dotfiles _plugins
    @printf "\nConfig all done!\n"

# misc tidy up
[group('config')]
tidydirs:
    @rmdir ~/Public ~/Templates ~/Videos 2>/dev/null

#still to do
# configs
# figger out where age key will be sourced from
# chezmoi completions
# tmux plugins
# neovim plugins
# source bashrc


