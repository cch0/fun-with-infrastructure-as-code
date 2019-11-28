
resource "google_folder_iam_binding" "default" {  
  for_each = var.iam-role-memberships
  folder   = var.folder_id
  role     = each.key
  members  = each.value 
}