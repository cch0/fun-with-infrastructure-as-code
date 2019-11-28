
locals {
    # produce a map with network name as key and list of subnet configs as value.
    # this variable is not being used, only kept here for illustration.
    subnets_map = {
      for name, config in var.vpc_config: 
          name => config.subnet_config
    }

    # produce a list, each element is a modified subnet config object which also
    # includes information such as network name and region so that each object 
    # has necessary information in order to create a subnetwork.
    subnets_config_list = flatten([
      for name in keys(var.vpc_config): [
        for config in var.vpc_config[name].subnet_config: {
          # vpc network name
          network_name          = name
          # subnetwork name
          name                  = config.name
          ip                    = config.ip
          region                = var.vpc_config[name].region
          description           = config.description
          enable_private_access = config.enable_private_access
          enable_flow_logs      = config.enable_flow_logs
          secondary_ip_range    = config.secondary_ip_range
        }
      ]
    ])

    # from the list, create a map with network_name_subnet_name as key.
    # map is needed in order to use for_each in resource block
    subnets_config_map = {
      for subnet_config in local.subnets_config_list: 
        "${subnet_config.network_name}_${subnet_config.name}" => subnet_config
      
    }
}


resource "google_compute_network" "network" {
    for_each                        = var.vpc_config
    project                         = var.project_id
    name                            = each.key
    auto_create_subnetworks         = each.value.auto_create_subnetworks
    routing_mode                    = each.value.routing_mode
    description                     = each.value.description
    delete_default_routes_on_create = each.value.delete_default_routes_on_create
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each                 = local.subnets_config_map

  name                     = each.value.name
  ip_cidr_range            = each.value.ip
  region                   = each.value.region
  private_ip_google_access = each.value.enable_private_access
  enable_flow_logs         = each.value.enable_flow_logs
  network                  = each.value.network_name
  project                  = var.project_id
  secondary_ip_range       = each.value.secondary_ip_range
  description              = each.value.description

  depends_on = [ google_compute_network.network ]
}

