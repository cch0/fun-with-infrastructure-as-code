variable "GCP_SERVICE_ACCOUNT_KEY" {
  type = string
}

variable "folder_name" {
  type = string
}

variable "folder_prefix" {
  type = string
}

variable "parent_folder_id" {
  type = string
}

variable "iam-role-memberships" {
  type = map(list(string))
}