# ══════════════════════════════════════════════
# Module: fabric-rbac
# Assigns Fabric workspace roles to Entra ID
# principals across the three medallion layers.
#
# Role matrix:
#   bronze  → Admin only (raw data, restricted)
#   silver  → Admin + Contributor
#   gold    → Admin + Contributor + Viewer
# ══════════════════════════════════════════════

# ── Admin role on ALL three workspaces ────────
resource "fabric_workspace_role_assignment" "admin" {
  for_each = {
    for pair in flatten([
      for layer, ws_id in var.workspace_ids : [
        for principal in var.admin_principals : {
          key       = "${layer}-${principal}"
          ws_id     = ws_id
          principal = principal
        }
      ]
    ]) : pair.key => pair
  }

  workspace_id = each.value.ws_id
  principal_id = each.value.principal
  role         = "Admin"
}

# ── Contributor role on Silver & Gold only ────
resource "fabric_workspace_role_assignment" "contributor" {
  for_each = {
    for pair in flatten([
      for layer, ws_id in var.workspace_ids : [
        for principal in var.contributor_principals : {
          key       = "${layer}-${principal}"
          ws_id     = ws_id
          principal = principal
        }
      ]
      if contains(["silver", "gold"], layer)
    ]) : pair.key => pair
  }

  workspace_id = each.value.ws_id
  principal_id = each.value.principal
  role         = "Contributor"
}

# ── Viewer role on Gold only ──────────────────
resource "fabric_workspace_role_assignment" "viewer" {
  for_each = {
    for pair in flatten([
      for layer, ws_id in var.workspace_ids : [
        for principal in var.viewer_principals : {
          key       = "${layer}-${principal}"
          ws_id     = ws_id
          principal = principal
        }
      ]
      if layer == "gold"
    ]) : pair.key => pair
  }

  workspace_id = each.value.ws_id
  principal_id = each.value.principal
  role         = "Viewer"
}
