output "admin_assignment_ids" {
  description = "Map of Admin role assignment resource IDs."
  value       = { for k, v in fabric_workspace_role_assignment.admin : k => v.id }
}

output "contributor_assignment_ids" {
  description = "Map of Contributor role assignment resource IDs."
  value       = { for k, v in fabric_workspace_role_assignment.contributor : k => v.id }
}

output "viewer_assignment_ids" {
  description = "Map of Viewer role assignment resource IDs."
  value       = { for k, v in fabric_workspace_role_assignment.viewer : k => v.id }
}
