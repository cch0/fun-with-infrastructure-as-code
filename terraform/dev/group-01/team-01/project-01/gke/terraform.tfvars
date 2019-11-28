# key is the cluster name
cluster_config = {
    "cluster-01" : {
        location           : "us-central1"
        initial_node_count : 1
        min_master_version : "1.13.10-gke.0"

        node_config        : {
            preemptible   : true
            machine_type  : "n1-standard-1"
            instance_tags : [ "foo", "bar" ]
            labels        : {
                "label-01" : "value-01"
                "label-02" : "value-02"
            }
        }
    }
}

# each key defined here must have had the same key defined in cluster_config
node_pool_config = {
    "cluster-01" : {
        "pool-01" : {
            preemptible   : true
            machine_type  : "n1-standard-1"
            instance_tags : [ "foo", "bar" ]
            labels        : {
                "pool-01" : "value-01"
            },
            node_count    : 1
        }, 
        // "pool-02" : {
        //     preemptible   : true
        //     machine_type  : "n1-standard-1"
        //     instance_tags : [ "foo", "bar" ]
        //     labels        : {
        //         "pool-02" : "value-02"
        //     },
        //     node_count    : 1
        // },      
    },
    // "cluster-02" : {
    //     "pool-03" : {
    //         preemptible   : true
    //         machine_type  : "n1-standard-1"
    //         instance_tags : [ "foo", "bar" ]
    //         labels        : {
    //             "pool-03" : "value-03"
    //         },
    //         node_count    : 1
    //     },
    // }
}

