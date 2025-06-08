mod dra "../modules/dra.just"


[group('install')]
dra-installs:
    # Dra installs
    # #############################################

    # rage encryption, used by chezmoi
    @just dra::multi "str4d/rage" "rage rage-keygen rage-mount"

    # chezmoi a dotfile manager
    @just dra::install "twpayne/chezmoi" 

    # # dra can't install neovim as it creates dirs, use as a downloader only
    # @just dra::download "neovim/neovim"
    # # tar extract into /opt
    # @sudo tar --directory=/opt -xzf /tmp/nvim*.tar.gz

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
