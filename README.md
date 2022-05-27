TL;DR: 

    $ cd ~/init
    $ ./configure
    $ invoke genesis
    $ ..; rm -r init

This tool installs a developer workstation with a bunch of tools that have their configs sucked
down from a github repo. 

Development work (in python) is intended to be edited locally on the bare-metal using vim
and the *execution* of the code is done in a container.  This is done to avoid
versioning problems with python libraries etc.
(other strategies would be to use pyenv or venv but these have their own problems)

So as far as possible we try to install with the system package manager. 
pip, npm etc are only used if absolutely no other way to get the package. 

Note that any pip installs are using *system* python. So want to keep *system* python as
clean as possible.
