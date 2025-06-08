

[private]
_dra := "https://raw.githubusercontent.com/devmatteini/dra/refs/heads/main/install.sh"
[private]
_rust := "https://sh.rustup.rs"
[private]
_aws := "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
[private]
_uv := "https://astral.sh/uv/install.sh"
[private]
_nvm := "https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh"

export NVM_DIR :="$HOME/.config/nvm"
export PROFILE :="/dev/null" 
[group('install')]
curl-installs:
    # Curl installs
    # #############################################

    # Install rust
    @curl --proto '=https' --tlsv1.2 {{ _rust }} --silent --show-error --fail|sh -s -- -y --no-modify-path

    # Install dra (a Github downloader)
    @curl --proto '=https' --tlsv1.2 --silent --show-error --fail {{ _dra }} | sudo bash -s -- --to /usr/local/bin/

    # Install AWS CLI
    @curl --proto '=https' --tlsv1.2 --silent --show-error --fail {{ _aws }} -o "/tmp/awscliv2.zip"
    @unzip -q /tmp/awscliv2.zip -d /tmp
    @cd /tmp; sudo ./aws/install || cd /tmp; sudo ./aws/install --update
    # cleanup
    @rm /tmp/awscliv2.zip; rm -r /tmp/aws

    # Install uv the python package manager
    @curl --proto '=https' --tlsv1.2 --location --silent --show-error {{ _uv }} | sh

    # # Install nvm, the nodejs version manager
    # @mkdir ~/.config/nvm
    # @curl --proto '=https' --tlsv1.2 --location --silent --show-error {{ _nvm }} | bash
