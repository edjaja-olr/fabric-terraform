# ════════════════════════════════════════════
# Demo Environment – terraform.tfvars
# ════════════════════════════════════════════
# Sensitive values (subscription_id, tenant_id,
# client_id, client_secret) are injected via
# GitHub Actions secrets – do NOT hardcode here.
# ════════════════════════════════════════════

environment  = "demo"
project_name = "medallion"
location     = "East US"
capacity_sku = "F64"

tags = {
  managed_by  = "terraform"
  project     = "microsoft-fabric-medallion"
  environment = "demo"
  owner       = "data-engineering"
  cost_center = "de-001"
}

# Capacity admins – replace with real UPNs or object IDs
capacity_admin_upns = [
  # "admin@contoso.com"
]

# Workspace admins (Entra object IDs)
workspace_admins = [
  # "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
]

# Contributor access on Silver & Gold
workspace_contributors = [
  # "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
]

# Read-only access on Gold only
workspace_viewers = [
  # "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
]

enable_git_integration = false
enable_schemas         = false
