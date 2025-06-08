[group('install')]
git-installs:
    #!/usr/bin/env sh
    META={{ executable_directory() }}/metatools
    if [ ! -d $META ]; then
      cd {{ executable_directory() }}
      git clone https://github.com/chad-betamax/metatools.git 
    else
      # if already installed get latest commit  
      cd $META; git pull
    fi

