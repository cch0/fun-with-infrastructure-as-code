
# create a folder
module "folder" {
  source = "../../../modules/folder"
  folder = {
    name   = var.folder_name
    prefix = var.folder_prefix
    parent = var.parent_folder_id
  }
}

# iam roles membership assignment
module "folder-iam" {
  source               = "../../../modules/folder-iam"
  folder_id            = module.folder.folder_id
  iam-role-memberships = var.iam-role-memberships
}