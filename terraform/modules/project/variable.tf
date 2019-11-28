variable "project_config" {
  type = object({
    name                = string
    folder_id           = string
    auto_create_network = bool
  })
}

variable "billing_account" {
  type = string
}
