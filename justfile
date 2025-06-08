import 'installs/apt.just'
import 'installs/curl.just'
import 'installs/dra.just'
import 'installs/git.just'
import 'configs.just'

_default:
    @just --list

[private]
_paths := "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

_tidypath:
    @echo 'tidying path'
    @echo 'PATH="{{ _paths }}"' | sudo tee /etc/environment > /dev/null

# install all the things
[group('install')]
install: _tidypath apt-install curl-install dra-installs


# deploy dotfiles and plugins for all your programs
[group('config')]
config: _dotfiles _bash_completions _plugins _misc
    @printf "\nConfig all done!\n If anything went wrong, a tar of the dotfiles is in /tmp\nDelete this if not needed\n"


# still to do
#  neovim plugins
#  config AWS ie certs logins etc
#  source bashrc at very end (for the shell where the spawn is run)




