import 'installs.just'
import 'configs.just'

_default:
    @just --list


# Install all the things
[group('install')]
install: _tidypath apt-installs curl-installs dra-installs


# deploy dotfiles and plugins for all your programs
[group('config')]
config: _dotfiles _plugins _misc
    @printf "\nConfig all done!\n"


#still to do
# configs
# figger out where age key will be sourced from
# chezmoi completions
# tmux plugins
# neovim plugins
# source bashrc at very end


