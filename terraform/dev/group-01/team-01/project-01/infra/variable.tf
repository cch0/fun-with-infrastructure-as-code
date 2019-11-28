variable "GCP_SERVICE_ACCOUNT_KEY" {
  type = string
}

variable "project_name" {
    type = string
}

variable "iam-role-memberships" {
  type = map(list(string))
}

variable "billing_account" {
  type = string
}
