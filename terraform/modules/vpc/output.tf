output "vpcs" {
    value = google_compute_network.network
}

output "subnets" {
    value = [ 
        for name, subnet in google_compute_subnetwork.subnetwork:
            subnet
    ]
}