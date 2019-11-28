data "terraform_remote_state" "parent" {
  backend = "gcs"
  config = {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/team-01/project-01/infra"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/team-01/vpc"
  }
}

locals {
    project_id = "${data.terraform_remote_state.parent.outputs.project_id}"
}

module "gke" {
    source           = "../../../../../modules/gke"
    project_id       = local.project_id
    cluster_config   = var.cluster_config 
    node_pool_config = var.node_pool_config
}
