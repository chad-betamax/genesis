[group('config')]
_dotfiles:
    @printf 'backup saved to /tmp\ndeploying dotfiles...\n'
    @chezmoi archive --output=/tmp/dotfiles_rescue.tar.gz
    @chezmoi init --apply https://github.com/chad-betamax/dotfiles.git
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

[group('config')]
_bash_completions:
    @mkdir -p ~/.config/bash/completions
    # for just
    @just --completions bash > ~/.config/bash/completions/just.bash
    # for chezmoi
    @chezmoi completion bash --output=~/.config/bash/completions/chezmoi.bash
    # for gh, the Github cli
    @gh completion --shell bash > ~/.config/bash/completions/gh.bash

    # set them all executable
    @chmod +x ~/.config/bash/completions/*.bash

# misc tidy up
[group('config')]
_misc:
    # Remove annoying default dirs if they exist
    # @if [ -d "$dir_path" ]; then
    # @rmdir ~/Public ~/Templates ~/Videos 2>/dev/null

