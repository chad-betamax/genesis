BINARIES := direnv bat htop httpie silversearcher-ag\
       	    vim\
	    vcsh myrepos\
	    podman

install:
	sudo apt-get update
	sudo apt-get install -y $(BINARIES) 

config:
	vcsh clone github.com:chad-betamax/bash.git



workstation: install config 
