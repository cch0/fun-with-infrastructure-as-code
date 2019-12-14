from pulumi_gcp import container, pulumi

from package import config_util


def provision(config: dict, project_id: str):
    if 'gke' in config:
        gke_config = config['gke']

        # node pool
        if 'node_pool_config' in gke_config:
            cluster_node_pool_configs = gke_config['node_pool_config']

            for cluster_name in cluster_node_pool_configs.keys():

                cluster = container.Cluster.get(cluster_name + '_read', 'project-04-2b8004a6/us-central1/cluster-04')

                # print(cluster)

                node_pool_configs = cluster_node_pool_configs[cluster_name]

                for node_pool_name in node_pool_configs.keys():
                    node_pool_config = node_pool_configs[node_pool_name]

                    node_pool = container.NodePool(node_pool_name,
                                                   name=node_pool_name,
                                                   location=cluster.location,
                                                   project='project-04-2b8004a6',
                                                   cluster='cluster-04',
                                                   management=node_pool_config['management'],
                                                   autoscaling=node_pool_config['autoscaling'],
                                                   node_config=node_pool_config['node_config'],
                                                   # // optional
                                                   max_pods_per_node=config_util.get(node_pool_config,
                                                                                     'max_pods_per_node', 8),
                                                   initial_node_count=config_util.get(node_pool_config,
                                                                                      'initial_node_count', 1)
                                                   )

                    pulumi.export('node_pool_id:' + cluster_name + '-' + node_pool_name, node_pool.id)
