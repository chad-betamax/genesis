import 'installs.just'
import 'configs.just'

_default:
    @just --list


# Install all the things
[group('install')]
install: _tidypath apt-installs curl-installs dra-installs


# deploy dotfiles and plugins for all your programs
[group('config')]
config: _dotfiles _bash_completions _plugins _misc
    @printf "\nConfig all done!\n"


#still to do
# neovim plugins
# source bashrc at very end (for the shell where the spawn is run)


