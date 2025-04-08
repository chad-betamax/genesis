# module for installing packages with apt package manager
get package:
    @sudo apt-get --assume-yes install {{ package }}

    # add repo for latest git
    @sudo add-apt-repository --yes ppa:git-core/ppa
    # and update cache
    @sudo apt update
    @sudo apt autoremove
    

