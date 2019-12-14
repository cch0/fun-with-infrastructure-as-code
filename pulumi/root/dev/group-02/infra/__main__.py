from package import config_util
from package import folder
from package import folder_iam

config = config_util.read('config.yaml')

parent_folder_id = config_util.get_parent_folder_id_from_stack(config)

folder_config = config['folder']

# provision folder
folder = folder.provision(folder_config, parent_folder_id)

# iam roles
folder_iam.provision(folder_config, folder.id)
