COMMITNAME := Doug
COMMITEMAIL := doug@phoenox.net
HOOKDIR := ~/.config/vcsh/hooks-enabled
BINARIES := direnv bat htop httpie silversearcher-ag\
       	    vim\
	    vcsh myrepos\
	    podman

install:
	sudo apt-get update
	sudo apt-get install -y $(BINARIES) 

config:
	@vcsh list
	@if test ! -d $(HOOKDIR); then mkdir $(HOOKDIR); fi
	@cp pre-merge-unclobber $(HOOKDIR)/
	@cp ./mrconfig ~/.mrconfig
	@git config --global user.email $(COMMITEMAIL)
	@git config --global user.name $(COMMITNAME)
	@git config --global init.defaultBranch main

repos:
	cd ~; mr checkout

mate:
	@if test -f ~/mate-settings; then dconf load / <~/mate-settings; rm ~/mate-settings; fi
	
box: install config repos mate
