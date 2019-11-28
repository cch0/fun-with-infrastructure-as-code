output "gke_cluster" {
    value = google_container_cluster.default
}

output "node_pool_config_list" {
    value = local.node_pool_config_list
}

output "node_pool_config_map" {
    value = local.node_pool_config_map
}