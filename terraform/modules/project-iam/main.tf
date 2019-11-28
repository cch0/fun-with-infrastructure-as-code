resource "google_project_iam_binding" "default" {
    for_each = var.iam-role-memberships
    project  = var.project_id
    role     = each.key
    members  = each.value 
}