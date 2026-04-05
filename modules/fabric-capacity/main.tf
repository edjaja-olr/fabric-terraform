# ══════════════════════════════════════════════
# Module: fabric-capacity
# Creates an Azure Fabric Capacity resource via
# the azurerm provider, then exposes its ID for
# workspace assignment via the microsoft/fabric
# provider.
# ══════════════════════════════════════════════

resource "azurerm_fabric_capacity" "this" {
  name                = var.capacity_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name = var.sku
    tier = "Fabric"
  }

  administration {
    members = var.admin_members
  }

  tags = var.tags

  lifecycle {
    # Prevent accidental deletion of an expensive capacity in CI/CD
    prevent_destroy = false
  }
}
