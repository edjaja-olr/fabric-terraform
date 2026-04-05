output "lakehouse_id" {
  description = "Fabric Lakehouse GUID."
  value       = fabric_lakehouse.this.id
}

output "lakehouse_name" {
  description = "Lakehouse display name."
  value       = fabric_lakehouse.this.display_name
}

output "workspace_id" {
  description = "The workspace this lakehouse belongs to."
  value       = fabric_lakehouse.this.workspace_id
}
