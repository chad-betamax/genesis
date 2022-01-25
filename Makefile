GITUSER := Doug
EMAIL := doug@phoenox.net
KEY := ~/.ssh/id_github
FLAGS := -oStrictHostKeyChecking=no -oIdentitiesOnly=yes
GIT_SSH := GIT_SSH_COMMAND="ssh $(FLAGS) -i $(KEY)"
BINARIES := direnv bat htop httpie silversearcher-ag\
            vim\
            vcsh myrepos\
            podman
GITHUB := git@github.com:chad-betamax
REPOS := ~/.config/vcsh/repo.d

install:
	@sudo apt-get update
	@sudo apt-get install -y $(BINARIES)
	@vcsh list
	@if test ! -d ~/.config/vcsh/hooks-enabled;\
	 then\
	 	mkdir ~/.config/vcsh/hooks-enabled;\
	 fi

config:
	@git config --global user.email $(EMAIL)
	@git config --global user.name $(GITUSER)
	@git config --global init.defaultBranch main
	@cp pre-merge-unclobber ~/.config/vcsh/hooks-enabled/

bash:
	@if test ! -d $(REPOS)/bash.git;\
         then\
                $(GIT_SSH) vcsh clone -b main $(GITHUB)/bash.git bash;\
         else\
                echo 'bash already cloned';\
         fi

mate:
	@if test ! -d $(REPOS)/mate.git;\
         then\
                $(GIT_SSH) vcsh clone -b main $(GITHUB)/mate.git bash\
                && dconf load / <~/mate-settings\
                && rm ~/mate-settings;\
         else\
                echo 'mate already cloned';\
         fi

box: install config bash mate

