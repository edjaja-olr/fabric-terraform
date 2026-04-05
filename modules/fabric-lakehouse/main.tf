# ══════════════════════════════════════════════
# Module: fabric-lakehouse
# Creates a Fabric Lakehouse inside a workspace.
# Optionally enables the lakehouse schema feature
# (preview) for Delta table namespacing.
# ══════════════════════════════════════════════

resource "fabric_lakehouse" "this" {
  workspace_id = var.workspace_id
  display_name = var.lakehouse_name
  description  = "Lakehouse for the ${var.lakehouse_name} layer – managed by Terraform."

  # Schema feature (requires Fabric preview opt-in)
  dynamic "properties" {
    for_each = var.enable_schemas ? [1] : []
    content {
      enable_schemas = true
    }
  }
}
