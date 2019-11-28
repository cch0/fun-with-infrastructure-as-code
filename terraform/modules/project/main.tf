resource "random_id" "id" {
  byte_length = 4
}

resource "google_project" "default" {
  name                = "${var.project_config.name}"
  project_id          = "${var.project_config.name}-${random_id.id.hex}"
  folder_id           = var.project_config.folder_id
  auto_create_network = var.project_config.auto_create_network
  billing_account     = var.billing_account
}

