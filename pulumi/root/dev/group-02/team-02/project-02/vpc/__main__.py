from package import config_util
from package import vpc

config = config_util.read('config.yaml')

project_config = config['project']

project_id = config_util.get_project_id_from_stack(config)

# provision network and subnet
vpc.provision(project_config, project_id)
