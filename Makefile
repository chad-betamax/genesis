GITUSER := Doug
EMAIL := doug@phoenox.net
KEY := ~/.ssh/id_github
FLAGS := -oStrictHostKeyChecking=no -oIdentitiesOnly=yes 
GIT_SSH := GIT_SSH_COMMAND="ssh $(FLAGS) -i $(KEY)"
HOOKDIR := ~/.config/vcsh/hooks-enabled
BINARIES := direnv bat htop httpie silversearcher-ag\
       	    vim\
	    vcsh myrepos\
	    podman

install:
	sudo apt-get update
	sudo apt-get install -y $(BINARIES) 
	vcsh list
	if test ! -d $(HOOKDIR); then mkdir $(HOOKDIR); fi

config:
	git config --global user.email $(EMAIL)
	git config --global user.name $(GITUSER)
	git config --global init.defaultBranch main
	cp pre-merge-unclobber $(HOOKDIR)/

repos:
	mr --trust-all checkout

mate:
	dconf load / <~/mate-settings
	rm ~/mate-settings
	
box: install config repos mate
