import 'installs.just'
import 'configs.just'

_default:
    @just --list

# install all the things
[group('install')]
install: _tidypath apt-installs curl-installs dra-installs


# deploy dotfiles and plugins for all your programs
[group('config')]
config: _dotfiles _bash_completions _plugins _misc
    @printf "\nConfig all done!\n If anything went wrong, a tar of the dotfiles is in /tmp\nDelete this if not needed\n"


# still to do
#  neovim plugins
#  config AWS ie certs logins etc
#  source bashrc at very end (for the shell where the spawn is run)


