# module for installing packages with apt package manager
get package:
    @sudo apt-get --assume-yes install {{ package }}

_signalkey := "https://updates.signal.org/desktop/apt/keys.asc"
initialise:
    # Install official Signal software signing key
    @curl --location --proto '=https' --tlsv1.2 {{ _signalkey }} --silent --show-error --fail| gpg --dearmor > /tmp/signal-key.gpg
    @cat /tmp/signal-key.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

    # add repo for latest git
    @sudo add-apt-repository --yes ppa:git-core/ppa
    # and update cache
    @sudo apt update
    @sudo apt autoremove
    

