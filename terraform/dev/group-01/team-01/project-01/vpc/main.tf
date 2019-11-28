data "terraform_remote_state" "parent" {
  backend = "gcs"
  config = {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/team-01/project-01/infra"
  }
}

locals {
    project_id = "${data.terraform_remote_state.parent.outputs.project_id}"
}

module "vpc" {
    source     = "../../../../../modules/vpc"
    project_id = local.project_id
    vpc_config = var.vpc_config
}
