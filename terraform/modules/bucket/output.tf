
locals {
    acls = {
        for acl in google_storage_bucket_acl.default:
        acl.bucket => {
            id: acl.id,
            predefined_acl: acl.predefined_acl,
            role_entity: acl.role_entity,
        }
    }
}

output "buckets" {
    value = {
        for bucket in google_storage_bucket.default:
        bucket.name => {            
            self_link:  bucket.self_link,
            url: bucket.url,
            acl: lookup(local.acls, bucket.name, {}),
        }
    }
}