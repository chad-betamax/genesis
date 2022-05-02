

misc = ['direnv', 'bat', 'htop', 'silversearcher-ag', 'pwgen', 'cloc']
web = ['curl', 'httpie', 'jq']
containers = ['podman', 'crun', 'slirp4netns']
edit = ['vim']
conf = ['vcsh', 'myrepos']

def func_with_args(arg_first, arg_second):
    for app in arg_first:
        print(app)
    for app in arg_second:
        print(app)
    return True

def task_call_func():
    return {'actions': [(func_with_args, [], web, conf)], 'verbosity': 2,}
