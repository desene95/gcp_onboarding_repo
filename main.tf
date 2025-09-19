resource "random_id" "project_suffix" {
  for_each = var.projects
  byte_length = 4   # generates 6 hex characters
}

resource "google_project_service" "services" {
  for_each = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])

  project = "tough-bearing-472602-p8"
  service = each.key
}

resource "google_folder" "engineering" {
  display_name = "Engineering"
  parent       = "organizations/${var.org_id}"
}

resource "google_project" "projects" {
  for_each        = var.projects  
  name            = "${each.value.name}-${random_id.project_suffix[each.key].hex}"
  project_id = "${each.key}-${random_id.project_suffix[each.key].hex}"
  folder_id = google_folder.engineering.id
  #org_id     = var.org_id
  billing_account = var.billing_account_id

  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

locals {
  project_api_combos = flatten([
    for proj_key, proj in google_project.projects : [
      for api in var.enabled_apis : {
        project_key = proj_key
        project_id  = proj.project_id
        api         = api
      }
    ]
  ])
}

resource "google_project_service" "enabled_apis" {
  for_each = { for idx, combo in local.project_api_combos : "${combo.project_key}-${combo.api}-${idx}" => combo }

  project = each.value.project_id
  service = each.value.api
}



#Write outputs to a file
resource "local_file" "tf_outputs" {
  content = yamlencode({
    for k, v in google_project.projects :
    upper(element(split("-", v.project_id), 1)) => {
      project_id     = v.project_id
      folder_id      = v.folder_id
      project_number = v.number
      project_path   = "${v.folder_id}/${v.number}"
    }
  })

  filename = "${path.module}/outputs.yaml"
}

resource "github_repository_file" "outputs_json" {
  repository = "gcp_foundation_repo"
  file       = "outputs.yaml"          # path inside the repo
  content    = local_file.tf_outputs.content
  branch     = "main"
  commit_message = "Update outputs.json from projects repo"
  depends_on = [ google_project.projects, local_file.tf_outputs ]
}