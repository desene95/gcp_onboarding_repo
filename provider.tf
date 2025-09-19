terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0" # pick a version compatible with your setup
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  project = "tough-bearing-472602-p8" # the project you use to manage org-level resources
  region  = "us-central1"
}

provider "github" {
  token = var.github_token
  owner = "desene95"
}