
## Getting Data Ready For Working With Terraform's `for_each` Meta-Argument

[for_each](https://www.terraform.io/docs/configuration/resources.html#for_each-multiple-resource-instances-defined-by-a-map-or-set-of-strings) was added in Terraform 0.12.6 and has given us the opportunity to create multiple resources of the same type in a much easier way than what was possible prior to this release.

Using an example here, we can see how we can use this new syntax when creating multiple GKE clusters and node pools.

Our first goal is to create GKE cluster resource using something similar to the snippet below.



```
resource "google_container_cluster" "default" {
    for_each           = var.cluster_config             <- a map or set is required here 
    project            = var.project_id
    name               = each.key
    location           = each.value.location
    node_version       = each.value.min_master_version
    min_master_version = each.value.min_master_version
    initial_node_count = each.value.initial_node_count
	...    
}
```    

Let's talk about data that is feeding the operation. Since `for_each` is expecting either a map or a set, we are using map as an example here. The `cluster_config` variable is defined as a Map with cluster name as key and an Object as value. It would look something like:

```
{
  "cluster-01" = {                              <- cluster name
    "initial_node_count" = 1
    "location" = "us-central1"
    "min_master_version" = "1.13.10-gke.0"
    "node_config" = {                           <- default node pool configuration
      "instance_tags" = [
        "foo",
        "bar",
      ]
      "labels" = {
        "label-01" = "value-01"
        "label-02" = "value-02"
      }
      "machine_type" = "n1-standard-1"
      "preemptible" = true
    }
  }
}
```

Using cluster name as key ensures that cluster name would be unique within the map. Using Object to contain configuration properties for the cluster gives us the flexibility to make backward compatible changes at ease. Everything that is needed to create the cluster is defined together in one place and enclosed within this object.

The definition of `cluster_config` variable is shown below:

```
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
```

Nothing particularly special about GKE cluster creation. We can use the `cluster_config` variable as it is and feed it to `google_container_cluster`

Our second goal is to create node pools and this is what gets interesting. There can be zero or more additional node pools per cluster (in addition to default node pool). How do we create `google_container_node_pool` resource taking advantage of `for_each` and also have everything defined using single variable as opposed to one variable per node pool approach?

Since map key is unique, therefore we need a key for each node pool configuration. Since we want all node pool configuration for the same cluster to be defined together, we would like the map value to contain all node pool information instead of in separate places. 

Although we have a choice of putting cluster configuration and node pool configuration together in the same data object, we chose not to because:

* the entire object will become larger and harder to reason about, manageable but not absolutely needed.
* node pool configuration is for additional node pools (not for default one), managing them separately makes sense

An example of `node_pool_config` looks like the following:

```
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
        "pool-02" : {
            preemptible   : true
            machine_type  : "n1-standard-1"
            instance_tags : [ "foo", "bar" ]
            labels        : {
                "pool-02" : "value-02"
            },
            node_count    : 1
        },            
    },
    "cluster-02" : {
        "pool-03" : {
            preemptible   : true
            machine_type  : "n1-standard-1"
            instance_tags : [ "foo", "bar" ]
            labels        : {
                "pool-03" : "value-03"
            },
            node_count    : 1
        },
    }
}
```

`node_pool_config` is a map with cluster name as its key. Map value is itself a map with node pool name as its key and node pool configuration as its value. Using this data structure, we can ensure that the combination of cluster name and node pool name is unique.

`node_pool_config` variable is defined as:

```
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
```

Now we have our data structure defined from the input  perspective which give us what we want (uniqueness, single place to define resources), how do we use this to create `google_container_node_pool`? 

We are NOT able to use it as it is directly because we are not (yet?) able to have a loop-of-loop inside the Terraform `resource` block.

```
# this is not a valid terraform script
resource "google_container_node_pool" "default" {
	for_each = var.nodel_pool_config  <- loop through outer map
		for_each = each.map           <- loop through inner map
}
```

The solution is to perform data transformation in order to produce the data structure we can use with Terraform `resource`.

To recall, this is our input

```
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
    },
}
```

First transformation we are going to do is to produce a list. Element in the list is a new data structure with data from both the cluster level and individual node pool config level. This new data structure has a field called `key` which is the combination of cluster name and node pool name and is what we are going to use as map key when producing the final data structure.

```
node_pool_config_list = [
  {
    "cluster_name" = "cluster-01"
    "key" = "cluster-01_pool-01"          <- combination of cluster name and node pool name
    "location" = "us-central1"
    "node_pool_config" = {
      "instance_tags" = [
        "foo",
        "bar",
      ]
      "labels" = {
        "pool-01" = "value-01"
      }
      "machine_type" = "n1-standard-1"
      "node_count" = 1
      "preemptible" = true
    }
    "pool_name" = "pool-01"
  },
]
```

Once we have this list, second transformation would be turning this list into a map using `key` field as map key.

```
node_pool_config_map = {
  "cluster-01_pool-01" = {               <- combination of cluster name and node pool name
    "cluster_name" = "cluster-01"
    "key" = "cluster-01_pool-01"         
    "location" = "us-central1"
    "node_pool_config" = {
      "instance_tags" = [
        "foo",
        "bar",
      ]
      "labels" = {
        "pool-01" = "value-01"
      }
      "machine_type" = "n1-standard-1"
      "node_count" = 1
      "preemptible" = true
    }
    "pool_name" = "pool-01"
  }
}
```

Finally, we can feed this `node_pool_config_map` directly to `google_container_node_pool`.

```
resource "google_container_node_pool" "default" {
    for_each   = local.node_pool_config_map
    project    = var.project_id
    name       = each.value.pool_name
    location   = each.value.location
    cluster    = each.value.cluster_name
    node_count = each.value.node_pool_config.node_count
    ...
}
```

All the transformation is done within the `locals` block before calling `google_container_node_pool`

```
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
```

As you can see now, data transformation using `for` and nested loop has become very useful in terms of creating the data structure we can use together with `for_each` in the `resource` block. 

