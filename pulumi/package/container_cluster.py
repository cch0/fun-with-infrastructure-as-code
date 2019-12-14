from pulumi_gcp import container, pulumi

from package import config_util


def provision(config: dict, project_id: str):
    if 'gke' in config:
        gke_config = config['gke']

        if 'cluster_config' in gke_config:
            cluster_configs = gke_config['cluster_config']

            for cluster_name in cluster_configs.keys():
                cluster_config = cluster_configs[cluster_name]

                cluster = container.Cluster(cluster_name,
                                            name=cluster_name,
                                            project=project_id,
                                            network=cluster_config['network_id'],
                                            enable_binary_authorization=cluster_config['enable_binary_authorization'],
                                            enable_intranode_visibility=cluster_config['enable_intranode_visibility'],
                                            initial_node_count=cluster_config['initial_node_count'],
                                            location=cluster_config['location'],
                                            logging_service=cluster_config['logging_service'],
                                            min_master_version=cluster_config['min_master_version'],
                                            monitoring_service=cluster_config['monitoring_service'],
                                            remove_default_node_pool=cluster_config['remove_default_node_pool'],
                                            node_config=cluster_config['node_config'],
                                            vertical_pod_autoscaling=cluster_config['vertical_pod_autoscaling'],
                                            additional_zones=config_util.get(cluster_config, 'additional_zones'),
                                            addons_config=config_util.get(cluster_config, 'addons_config'),
                                            cluster_autoscaling=config_util.get(cluster_config, 'cluster_autoscaling'),
                                            cluster_ipv4_cidr=config_util.get(cluster_config, 'cluster_ipv4_cidr'),
                                            default_max_pods_per_node=config_util.get(cluster_config,
                                                                                      'default_max_pods_per_node'),
                                            master_auth=config_util.get(cluster_config, 'master_auth'),
                                            master_authorized_networks_config=config_util.get(cluster_config,
                                                                                              'master_authorized_networks_config'),
                                            network_policy=config_util.get(cluster_config, 'network_policy'),
                                            private_cluster_config=config_util.get(cluster_config,
                                                                                   'private_cluster_config'),
                                            ip_allocation_policy=config_util.get(cluster_config,
                                                                                 'ip_allocation_policy'),
                                            )

                pulumi.export('cluster_id:' + cluster_name, cluster.id)
