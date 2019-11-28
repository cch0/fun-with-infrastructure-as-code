output "gke_cluster" {
    value = module.gke.gke_cluster
}

output "node_pool_config_list" {
    value = module.gke.node_pool_config_list
}

output "node_pool_config_map" {
    value = module.gke.node_pool_config_map
}