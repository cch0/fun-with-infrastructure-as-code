from package import config_util
from package import container_cluster, container_node_pool

config = config_util.read('config.yaml')

project_config = config['project']

project_id = config_util.get_project_id_from_stack(config)

# provision gke cluster
container_cluster.provision(project_config, project_id)

# provision additional node pools
container_node_pool.provision(project_config, project_id)
