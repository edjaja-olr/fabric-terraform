# ╔══════════════════════════════════════════════════════════════════╗
# ║   Microsoft Fabric – Medallion Architecture                     ║
# ║   F64 Capacity  |  Bronze · Silver · Gold Workspaces            ║
# ║   Managed by Terraform  (microsoft/fabric ~> 1.9)               ║
# ╚══════════════════════════════════════════════════════════════════╝

# ─────────────────────────────────────────────
# 1. Azure Resource Group (hosts the capacity)
# ─────────────────────────────────────────────
resource "azurerm_resource_group" "fabric" {
  name     = "rg-${local.name_prefix}-fabric"
  location = var.location
  tags     = local.common_tags
}

# ─────────────────────────────────────────────
# 2. Fabric Capacity (F64)
# ─────────────────────────────────────────────
module "fabric_capacity" {
  source = "./modules/fabric-capacity"

  resource_group_name = azurerm_resource_group.fabric.name
  location            = azurerm_resource_group.fabric.location
  capacity_name       = local.capacity_name
  sku                 = var.capacity_sku
  admin_members       = var.capacity_admin_upns
  tags                = local.common_tags
}

# ─────────────────────────────────────────────
# 3. Medallion Workspaces (Bronze · Silver · Gold)
# ─────────────────────────────────────────────
module "workspace" {
  source   = "./modules/fabric-workspace"
  for_each = local.medallion_layers

  layer        = each.key
  display_name = each.value.display_name
  description  = each.value.description
  capacity_id  = module.fabric_capacity.fabric_capacity_id
}

# ─────────────────────────────────────────────
# 4. Lakehouses – one per workspace
# ─────────────────────────────────────────────
module "lakehouse" {
  source   = "./modules/fabric-lakehouse"
  for_each = local.medallion_layers

  workspace_id     = module.workspace[each.key].workspace_id
  lakehouse_name   = each.value.lakehouse
  enable_schemas   = var.enable_schemas

  depends_on = [module.workspace]
}

# ─────────────────────────────────────────────
# 5. RBAC – Workspace Role Assignments
# ─────────────────────────────────────────────
module "rbac" {
  source = "./modules/fabric-rbac"

  workspace_ids   = { for k, v in module.workspace : k => v.workspace_id }
  admin_principals       = var.workspace_admins
  contributor_principals = var.workspace_contributors
  viewer_principals      = var.workspace_viewers

  depends_on = [module.workspace]
}
