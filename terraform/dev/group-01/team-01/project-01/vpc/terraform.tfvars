
vpc_config = {
    "network-01": {
        description                     : "network-01",
        auto_create_subnetworks         : false,
        routing_mode                    : "GLOBAL",
        delete_default_routes_on_create : false,
        region                          : "us-central1",

        subnet_config: [
            {
                name                  : "subnet-01",
                ip                    : "10.10.10.0/24",                
                enable_private_access : false,
                enable_flow_logs      : false,
                description           : "",
                secondary_ip_range    : []
            },
            {
                name                  : "subnet-02",
                ip                    : "10.10.20.0/24",
                enable_private_access : false,
                enable_flow_logs      : false,
                description           : "",
                secondary_ip_range    : []
            },
        ]
    }
}
