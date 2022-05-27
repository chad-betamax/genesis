"""
we wanna use tools from the OS repos as far as possible.
Tools that are installed by non-OS package managers I wanna keep to the absolute
minimum. Eg we install python3-libtmux using apt rather than pip cos the version in
the apt repos is good enough.
"""


def packages():
    """ "
    tools and libraries that will get installed with apt-get.
    """
    tools = {
        # misc_tools
        "direnv": "per-project ENV vars",
        "bat": "cat on steroids",
        "htop": "top on steroids",
        "silversearcher-ag": "faster grep",
        "pwgen": "a password generator",
        "cloc": "count lines-of-code",
        # web_tools
        "curl": "download stuff",
        "httpie": "a CLI Postman",
        "jq": "CLI JSON processor",
        # DB_tools
        # 'postgresql-client-14': 'psql',
        #
        # edit_tools
        "tmux": "a terminal multiplexer",
        "vim": "the one-true-editor",
        "topydo": "a to-do list manager",
        "black": "python formatter",  # * see note below
        # dependencies
        "python3-pip": "package manager for system python",
        "python3-libtmux": "scripting library for tmux",
        "entr": "run arbitrary commands when files change",
        "xsel": "clipboard stuff, used by tmux-yank plugin",
        "xdotool": "simulate X11 events, used by tmux-resurrect plugin",
        "wmctrl": "control X11 stuff, used by tmux-resurrect plugin",
        # config_tools
        "vcsh": "version control for dotfiles",
        "myrepos": "treat multiple git repos as one",
        # container_tools
        "podman": "RedHat's answer to Docker",
        "crun": "lib needed by podman",
        "slirp4netns": "another lib needed by podman",
    }

    """
    * it's a bit confusing: why is a system-python black being installed
    when lots of work is done to run black (and linters) in containers and be called
    directly from vim????
    It's because  - what if the project you wanna black over doesn't use containers? ie the
    project is run on bare metal (likely your workstation) and is not for deployment
    in the cloud? Then the ENV vars etc are not gonna work and you need a local,
    system black. Grrr.
    This system black will be run as a standalone and I won't be integrating it into
    vim.
    """

    return tools


def apt():
    """
    Run the apt-get installer

    Note that "apt-get update" will have already been run by ../configure
    """
    tools = packages()
    exe = f"sudo apt-get install -y {' '.join(tools.keys())}"
    return exe
