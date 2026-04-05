# ─────────────────────────────────────────────
# Fabric Capacity
# ─────────────────────────────────────────────
output "fabric_capacity_id" {
  description = "The Fabric Capacity resource ID (Azure ARM ID)."
  value       = module.fabric_capacity.capacity_arm_id
}

output "fabric_capacity_name" {
  description = "The Fabric Capacity display name."
  value       = module.fabric_capacity.capacity_name
}

output "fabric_capacity_sku" {
  description = "The Fabric SKU deployed (e.g. F64)."
  value       = var.capacity_sku
}

# ─────────────────────────────────────────────
# Medallion Workspace IDs
# ─────────────────────────────────────────────
output "workspace_ids" {
  description = "Map of medallion layer → Fabric workspace GUID."
  value = {
    for k, v in module.workspace : k => v.workspace_id
  }
}

output "workspace_display_names" {
  description = "Map of medallion layer → workspace display name."
  value = {
    for k, v in module.workspace : k => v.display_name
  }
}

# ─────────────────────────────────────────────
# Lakehouse IDs
# ─────────────────────────────────────────────
output "lakehouse_ids" {
  description = "Map of medallion layer → Fabric Lakehouse GUID."
  value = {
    for k, v in module.lakehouse : k => v.lakehouse_id
  }
}

output "lakehouse_names" {
  description = "Map of medallion layer → Lakehouse display name."
  value = {
    for k, v in module.lakehouse : k => v.lakehouse_name
  }
}

# ─────────────────────────────────────────────
# Convenience – Fabric Portal Deep Links
# ─────────────────────────────────────────────
output "fabric_portal_links" {
  description = "Direct links to each workspace in the Microsoft Fabric portal."
  value = {
    for k, v in module.workspace : k => "https://app.fabric.microsoft.com/groups/${v.workspace_id}"
  }
}
