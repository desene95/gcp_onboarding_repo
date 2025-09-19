output "projects_info" {
  description = "Information about all created projects"
  value = {
    for proj_key, proj in google_project.projects :
    proj_key => {
      name          = proj.name
      project_id    = proj.project_id
      project_number = proj.number
    }
  }
}