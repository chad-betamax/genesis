GITUSER := Doug
EMAIL := doug@phoenox.net
KEY := ~/.ssh/id_github
FLAGS := -oStrictHostKeyChecking=no -oIdentitiesOnly=yes 
GIT_SSH := GIT_SSH_COMMAND="ssh $(FLAGS) -i $(KEY)"
BINARIES := direnv bat htop httpie silversearcher-ag\
       	    vim\
	    vcsh myrepos\
	    podman

install:
	sudo apt-get update
	sudo apt-get install -y $(BINARIES) 
	vcsh list
	mkdir ~/.config/vcsh/hooks-enabled

config:
	git config --global user.email $(EMAIL)
	git config --global user.name $(GITUSER)
	git config --global init.defaultBranch main
	cp pre-merge-unclobber ~/.config/vcsh/hooks-enabled/

bash:
	$(GIT_SSH) vcsh clone -b main git@github.com:chad-betamax/bash.git bash

mate:
	$(GIT_SSH) vcsh clone -b main git@github.com:chad-betamax/mate.git mate
	dconf load / <~/mate-settings
	rm ~/mate-settings
	
box: install config bash mate
