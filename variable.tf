variable "org_id" {
    default = "284474815861"
    type = string
  
}

variable "billing_account_id" {
    default = "01851B-A68A85-FA5895"
    type = string
  
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "projects" {
    type = map(object({
        name      = string
        folder_id = string
  }))
  description = "Map of projects to create"
  
}

variable "enabled_apis" {
  type    = list(string)
  default = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com",
    "bigquery.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "cloudresourcemanager.googleapis.com"

  ]
}

