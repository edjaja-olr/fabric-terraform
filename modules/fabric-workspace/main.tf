# ══════════════════════════════════════════════
# Module: fabric-workspace
# Creates a single Microsoft Fabric Workspace
# and assigns it to a Fabric Capacity.
# ══════════════════════════════════════════════

resource "fabric_workspace" "this" {
  display_name = var.display_name
  description  = var.description
  capacity_id  = var.capacity_id

  # Identity type for the workspace
  identity {
    type = "SystemAssigned"
  }
}
