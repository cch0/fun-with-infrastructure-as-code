data "terraform_remote_state" "parent" {
  backend = "gcs"
  config = {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/team-01/project-01/infra"
  }
}

locals {
    project_id   = "${data.terraform_remote_state.parent.outputs.project_id}"
    project_name = "${data.terraform_remote_state.parent.outputs.project_name}"
    prefix       = var.prefix == "" ? local.project_name : var.prefix
}

module "bucket" {
    source        = "../../../../../modules/bucket"
    project_id    = local.project_id
    prefix        = local.prefix
    bucket_config = var.bucket_config
}
