# module for installing packages with dra (https://github.com/devmatteini/dra) 
# which downloads a latest release from github and installs it no matter if tar.gz, deb file etc


# download, extract and install
install package:
    @sudo dra download --automatic --install --output /usr/local/bin/ {{ package }}

# download only; note the differnet target dir
download package:
    @dra download --automatic --output /tmp {{ package }}
