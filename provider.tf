provider "google" {
  credentials = var.GOOGLE_APPLICATION_CREDENTIALS
  project = "engineer-cloud-nprod"
  region  = "us-central1"
}
