variable "folder_id" {
    type = string
}

variable "iam-role-memberships" {
  type = map(list(string))
}