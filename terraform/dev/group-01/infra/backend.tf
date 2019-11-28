terraform {
  backend "gcs" {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/infra"
  }
}