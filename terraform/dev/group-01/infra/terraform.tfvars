folder_name      = "group-01"
folder_prefix    = "dev"
parent_folder_id = "folders/PARENT_FOLDER_ID"

iam-role-memberships = {
    "roles/resourcemanager.folderViewer" : [
        "group:GROUP_EMAIL",
    ]
}