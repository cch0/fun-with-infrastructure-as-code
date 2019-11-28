
data "terraform_remote_state" "parent" {
  backend = "gcs"
  config = {
    bucket  = "tf-provisioning"
    prefix  = "dev/group-01/team-01/project-01/infra"
  }
}

locals {
    project_id = "${data.terraform_remote_state.parent.outputs.project_id}"
}

resource "google_project_service" "compute" {
  project = local.project_id
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  project = local.project_id
  service = "container.googleapis.com"
  disable_on_destroy = false
}

