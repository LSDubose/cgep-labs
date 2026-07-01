terraform {
  required_version = ">= 1.6"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}

provider "google" {
  project = "project-2fb68a50-288b-470d-a7d"
  region  = "us-central1"
}

module "data_bucket" {
  source = "../../modules/compliant-gcs-bucket"

  gcp_project        = "project-2fb68a50-288b-470d-a7d"
  project_label      = "cgep-lab"
  environment        = "prod"
  retention_days     = 30
  bucket_name_suffix = "should-never-exist"
}
