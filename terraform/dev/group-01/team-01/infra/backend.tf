terraform {
  backend "gcs" {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/team-01/infra"
  }
}