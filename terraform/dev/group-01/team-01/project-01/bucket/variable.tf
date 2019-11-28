variable "GCP_SERVICE_ACCOUNT_KEY" {
  type = string
}

variable "prefix" {
    type    = string
    default = ""
}

variable "bucket_config" {
    type = map(object({
        storage_class      = string
        versioning_enabled = bool
        acl                = object({
            # either specify predefined_acl or role_entity but not both
            predefined_acl = string
            role_entity    = list(string)
        })
    }))
}