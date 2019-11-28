
locals {
    # Apply transformation to input variable in order to produce a data structure 
    # suitable for creating gke resources.

    # Step 1: produce a list with each element an object which has all necessary information
    # in order to create a node pool. "key" field is a combination of cluster name
    # and node pool name. This key will be used as map key in step 2.
    # It is important to make sure this key is unique across all clusters and node pools
    node_pool_config_list = flatten([
        for cluster_name in keys(var.node_pool_config):  [
            for pool_name in keys(var.node_pool_config[cluster_name]): {
                    key               = "${cluster_name}_${pool_name}"
                    pool_name         = pool_name
                    cluster_name      = cluster_name
                    location          = var.cluster_config[cluster_name].location
                    node_pool_config  = var.node_pool_config[cluster_name][pool_name]
            }            
        ]
    ])

    # Step 2: from the list created in step 1, create a map using "key" field value
    # from each element in the list. This map will be used in creating 
    # google_container_node_pool resource
    node_pool_config_map = {
        for config in local.node_pool_config_list:
            config.key => config
    }
}

resource "google_container_cluster" "default" {
    for_each           = var.cluster_config
    project            = var.project_id
    name               = each.key
    location           = each.value.location
    node_version       = each.value.min_master_version
    min_master_version = each.value.min_master_version
    initial_node_count = each.value.initial_node_count
    logging_service    = "logging.googleapis.com/kubernetes"
    monitoring_service = "monitoring.googleapis.com/kubernetes"

    master_auth {
        username = ""
        password = ""

        client_certificate_config {
            issue_client_certificate = false
        }
    }

    node_config {
        preemptible  = each.value.node_config.preemptible
        machine_type = each.value.node_config.machine_type

        oauth_scopes = [
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            "https://www.googleapis.com/auth/devstorage.read_only",
        ]

        metadata = {
            disable-legacy-endpoints = "true"
        }

        labels = each.value.node_config.labels

        tags = each.value.node_config.instance_tags
    }

    timeouts {
        create = "30m"
        update = "40m"
    }
}

resource "google_container_node_pool" "default" {
    for_each   = local.node_pool_config_map
    project    = var.project_id
    name       = each.value.pool_name
    location   = each.value.location
    cluster    = each.value.cluster_name
    node_count = each.value.node_pool_config.node_count

    node_config {
        preemptible  = each.value.node_pool_config.preemptible
        machine_type = each.value.node_pool_config.machine_type

        oauth_scopes = [
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            "https://www.googleapis.com/auth/devstorage.read_only",
        ]

        metadata = {
            disable-legacy-endpoints = "true"
        }

        labels = each.value.node_pool_config.labels

        tags = each.value.node_pool_config.instance_tags
    }

    depends_on = [ google_container_cluster.default ]
}