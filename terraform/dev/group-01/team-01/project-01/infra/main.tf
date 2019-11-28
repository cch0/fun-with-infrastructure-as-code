data "terraform_remote_state" "parent" {
  backend = "gcs"
  config = {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/team-01/infra"
  }
}

locals {
    folder_id = "${data.terraform_remote_state.parent.outputs.folder_id}"
}

module "project" {
    source          = "../../../../../modules/project"
    billing_account = var.billing_account
    project_config  = {
        name                = var.project_name
        folder_id           = local.folder_id
        auto_create_network = true
    }
}

module "project-iam" {
    source               = "../../../../../modules/project-iam"
    project_id           = module.project.project_id
    iam-role-memberships = var.iam-role-memberships
}