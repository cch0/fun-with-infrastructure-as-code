locals {
    prefix = var.folder.prefix == "" ? "" : "${var.folder.prefix}-"
}

resource "google_folder" "default" {
  display_name = "${local.prefix}${var.folder.name}"
  parent       = "${var.folder.parent}"
}
