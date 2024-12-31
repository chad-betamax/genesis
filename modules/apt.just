# module for installing packages with apt package manager
get package:
    @sudo apt-get --assume-yes install {{ package }}

