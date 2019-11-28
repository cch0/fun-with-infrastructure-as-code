variable "vpc_config" {
    type = map(object({
        auto_create_subnetworks         = bool
        routing_mode                    = string
        description                     = string
        delete_default_routes_on_create = bool
        region                          = string
        subnet_config = list(object({
            name                   = string
            ip                     = string
            description            = string
            enable_private_access  = bool
            enable_flow_logs       = bool
            secondary_ip_range     = list(object({
                range_name    = string
                ip_cidr_range = string
            }))
        }))

    }))
}

variable "project_id" {
    type = string
}