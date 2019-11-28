variable "prefix" {
    type = string
}

variable "location" {
    type = string
    default = "US"
}

variable "project_id" {
    type = string
}

variable "bucket_config" {
    type = map(object({
        storage_class = string
        versioning_enabled = bool
        acl = object({
            # either specify predefined_acl or role_entity but not both
            predefined_acl = string
            role_entity = list(string)
        })
    }))
}