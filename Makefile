GITUSER := Doug
EMAIL := doug@phoenox.net
SSHKEY := ~/.ssh/id_github
SSHFLAGS := -oStrictHostKeyChecking=no -oIdentitiesOnly=yes 
BINARIES := direnv bat htop httpie silversearcher-ag\
       	    vim\
	    vcsh myrepos\
	    podman

install:
	sudo apt-get update
	sudo apt-get install -y $(BINARIES) 

config:
	git config --global user.email $(EMAIL)
	git config --global user.name $(GITUSER)
	git config --global init.defaultBranch main
	git config --local core.hooksPath .githooks/
	GIT_SSH_COMMAND="ssh $(SSHFLAGS) -i $(SSHKEY)" vcsh clone -b main git@github.com:chad-betamax/bash.git bash

box: install config 
