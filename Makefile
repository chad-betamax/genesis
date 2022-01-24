GITUSER := Doug
EMAIL := doug@phoenox.net
KEY := ~/.ssh/id_github
FLAGS := -oStrictHostKeyChecking=no -oIdentitiesOnly=yes 
BINARIES := direnv bat htop httpie silversearcher-ag\
       	    vim\
	    vcsh myrepos\
	    podman

install:
	sudo apt-get update
	sudo apt-get install -y $(BINARIES) 
	vcsh list
	mkdir ~/.config/vcsh/repo.d/hooks-enabled

config:
	git config --global user.email $(EMAIL)
	git config --global user.name $(GITUSER)
	git config --global init.defaultBranch main
	cp pre-merge-unclobber ~/.config/vcsh/hooks-enabled/
	GIT_SSH_COMMAND="ssh $(FLAGS) -i $(KEY)" vcsh clone -b main git@github.com:chad-betamax/bash.git bash

box: install config 
