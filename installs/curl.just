
[private]
_rust := "https://sh.rustup.rs"
[group('curl')]
rust-install:
    @curl --proto '=https' --tlsv1.2 {{ _rust }} --silent --show-error --fail|sh -s -- -y --no-modify-path

[private]
_dra := "https://raw.githubusercontent.com/devmatteini/dra/refs/heads/main/install.sh"
[group('curl')]
dra-install:
    # dra, a Github downloader
    @curl --proto '=https' --tlsv1.2 --silent --show-error --fail {{ _dra }} | sudo bash -s -- --to /usr/local/bin/

[private]
_aws := "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
[group('curl')]
aws-cli-install:
    @curl --proto '=https' --tlsv1.2 --silent --show-error --fail {{ _aws }} -o "/tmp/awscliv2.zip"
    @unzip -q /tmp/awscliv2.zip -d /tmp
    @cd /tmp; sudo ./aws/install || cd /tmp; sudo ./aws/install --update
    # cleanup
    @rm /tmp/awscliv2.zip; rm -r /tmp/aws

[private]
_uv := "https://astral.sh/uv/install.sh"
[group('curl')]
uv-install:
    # uv the python package manager
    @curl --proto '=https' --tlsv1.2 --location --silent --show-error {{ _uv }} | sh

export NVM_DIR :="~/.config/nvm"
export PROFILE :="/dev/null" 
[private]
_nvm := "https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh"
[group('curl')]
nvm-install:
    # nvm, the nodejs version manager
    @mkdir ~/.config/nvm
    @curl: --proto '=https' --tlsv1.2 --location --silent --show-error {{ _nvm }} | bash

[group('install')]
curl-install: rust-install dra-install aws-cli-install uv-install nvm-install
