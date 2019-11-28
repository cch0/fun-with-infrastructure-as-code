locals {
    prefix = var.prefix == "" ? "" : "${var.prefix}-"
}

resource "google_storage_bucket" "default" {
    for_each      = var.bucket_config
    project       = var.project_id
    name          = "${local.prefix}${each.key}"
    location      = var.location
    storage_class = each.value.storage_class

    versioning     { 
        enabled = each.value.versioning_enabled
    }
}

resource "google_storage_bucket_acl" "default" {
    for_each       = var.bucket_config
    bucket         = "${local.prefix}${each.key}"
    predefined_acl = each.value.acl.predefined_acl == "" ? null : each.value.acl.predefined_acl
    role_entity    = length(each.value.acl.role_entity) == 0 ? null : each.value.acl.role_entity

    depends_on = [
        google_storage_bucket.default
    ]
}

