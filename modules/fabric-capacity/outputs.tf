output "capacity_arm_id" {
  description = "Full Azure ARM resource ID of the Fabric Capacity."
  value       = azurerm_fabric_capacity.this.id
}

output "fabric_capacity_id" {
  description = "Fabric Capacity GUID used for workspace assignment via the fabric provider."
  # The azurerm resource exposes the ARM id; the fabric provider accepts the ARM id directly
  # as the capacity_id on fabric_workspace.
  value = azurerm_fabric_capacity.this.id
}

output "capacity_name" {
  description = "Deployed capacity name."
  value       = azurerm_fabric_capacity.this.name
}
