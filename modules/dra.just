# module for installing packages with dra (https://github.com/devmatteini/dra) 
# which downloads a latest release from github and installs it no matter if tar.gz, deb file etc

# install & multi can be combined use conditional expression

# download, extract and install
install package:
    @sudo dra download --automatic --install --output /usr/local/bin/ {{ package }}

# download, extract and install a file with multiple binaries
multi package *bins:
    @sudo dra download --automatic {{prepend("--install-file ", bins)}} --output /usr/local/bin/ {{ package }}

# download only; note the different target dir
download package:
    @dra download --automatic --output /tmp {{ package }}




