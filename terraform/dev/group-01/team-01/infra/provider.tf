provider "google" {
  credentials = var.GCP_SERVICE_ACCOUNT_KEY
  version = "~> 2.17.0"
}
