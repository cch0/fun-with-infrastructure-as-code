import os


def get(name, default=None):
    if name in os.environ:
        return os.environ[name]

    if default is None:
        raise Exception('environment variable does not exist for:' + name)

    return default
