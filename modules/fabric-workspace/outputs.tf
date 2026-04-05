output "workspace_id" {
  description = "Fabric Workspace GUID."
  value       = fabric_workspace.this.id
}

output "display_name" {
  description = "Workspace display name."
  value       = fabric_workspace.this.display_name
}
