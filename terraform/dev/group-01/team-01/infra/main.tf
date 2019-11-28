
data "terraform_remote_state" "parent" {
  backend = "gcs"
  config  = {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/infra"
  }
}

locals {
  parent_folder_id = "${data.terraform_remote_state.parent.outputs.folder_id}"
}

# create a folder
module "folder" {
  source = "../../../../modules/folder"
  folder = {
    name   = var.folder_name
    prefix = var.folder_prefix
    parent = local.parent_folder_id
  }
}

# iam roles membership assignment
module "folder-iam" {
  source               = "../../../../modules/folder-iam"
  folder_id            = module.folder.folder_id
  iam-role-memberships = var.iam-role-memberships
}
