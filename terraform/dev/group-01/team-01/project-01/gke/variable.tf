variable "GCP_SERVICE_ACCOUNT_KEY" {
  type = string
}

variable "cluster_config" {
    // map key: cluster name
    // map value: cluster config for the cluster
    type = map(object({
        location           = string
        initial_node_count = number
        min_master_version = string
        // default node pool config
        node_config        = object({
            preemptible   = bool
            machine_type  = string
            instance_tags = list(string)
            labels        = map(string)
        })
    }))
}

variable "node_pool_config" {
    // outer map key: cluster name
    // outer map value: inner map
    // inner map key: pool name
    // inner map value: node pool config for the pool
    type = map(map(object({
        preemptible   = bool
        machine_type  = string
        instance_tags = list(string)
        labels        = map(string)
        node_count    = number
    })))
}