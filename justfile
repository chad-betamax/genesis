import 'installs.just'

_default:
    @just --list

_paths :="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
_tidypath:
    @echo 'PATH="{{ _paths }}"' | sudo tee /etc/environment > /dev/null



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
    MANAGER={{config_directory()}}/tmux/plugins/tpm
    if [ -d $MANAGER ]
    then
        printf "tpm already installed; doing updates...\n"
        $MANAGER/bin/clean_plugins
        $MANAGER/bin/update_plugins all
        # needed to catch new plugins 
        $MANAGER/bin/install_plugins
        printf "\n"
    else
        printf "installing tmux plugins"
        mkdir -p $MANAGER
        git clone https://github.com/tmux-plugins/tpm $MANAGER && $MANAGER/bin/install_plugins
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
# source bashrc at very end


