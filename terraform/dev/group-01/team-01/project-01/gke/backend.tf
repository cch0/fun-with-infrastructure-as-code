terraform {
  backend "gcs" {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/team-01/project-01/gke"
  }
}