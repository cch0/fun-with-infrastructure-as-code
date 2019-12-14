import yaml
from pulumi import StackReference


def read(config_file: str):
    with open(config_file) as f:
        config = yaml.load(f, Loader=yaml.FullLoader)

    return config


def get_from_stack(stack_name: str, name: str):
    stack = StackReference(stack_name)

    if stack is None:
        return None
    else:
        return stack.get_output(name)


def get_parent_folder_id_from_stack(config: dict):
    parent_folder_id = None

    # determine parent_folder_id
    if 'parent_stack_name' in config:
        print('key:parent_stack_name exists')
        parent_stack = StackReference(config['parent_stack_name'])
        parent_folder_id = parent_stack.get_output("folder_id")
    elif 'parent_folder_id' in config:
        print('key:parent_folder_id exists')
        parent_folder_id = config['parent_folder_id']

    return parent_folder_id


def get_project_id_from_stack(config: dict):
    project_id = None

    if 'parent_stack_name' in config:
        print('key:parent_stack_name exists')
        parent = StackReference(config['parent_stack_name'])
        project_id = parent.get_output("project_id")

    return project_id


def get(config: dict, name: str, default_value=None):
    if name in config:
        return config[name]
    elif default_value is not None:
        return default_value
    else:
        return None
