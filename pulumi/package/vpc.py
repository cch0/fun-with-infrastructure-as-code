from pulumi_gcp import compute, pulumi


def provision(config: dict, project_id: str):
    network_configs = config['networks']

    for network_name in network_configs.keys():
        network_config = network_configs[network_name]
        auto_create_subnetworks = network_config['auto_create_subnetworks']
        delete_default_routes_on_create = network_config['delete_default_routes_on_create']
        routing_mode = network_config['routing_mode']
        region = network_config['region']

        print('provision network:', network_name)

        # provision network
        network = compute.Network(network_name,
                                  auto_create_subnetworks=auto_create_subnetworks,
                                  project=project_id,
                                  name=network_name,
                                  delete_default_routes_on_create=delete_default_routes_on_create,
                                  routing_mode=routing_mode)

        pulumi.export('network_id:' + network_name, network.id)

        # provision subnet
        if 'subnets' in network_config:
            subnet_configs = network_config['subnets']

            for subnet_name in subnet_configs.keys():
                subnet_config = subnet_configs[subnet_name]
                resource_name = network_name + '-' + subnet_name

                subnet = compute.Subnetwork(resource_name,
                                            name=subnet_name,
                                            network=network.id,
                                            project=project_id,
                                            description=subnet_config['description'],
                                            ip_cidr_range=subnet_config['ip_cidr_range'],
                                            private_ip_google_access=subnet_config['private_ip_google_access'],
                                            region=region,
                                            secondary_ip_ranges=subnet_config['secondary_ip_ranges']
                                            )

                pulumi.export('subnet_id:' + resource_name, subnet.id)

