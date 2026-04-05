# ─────────────────────────────────────────────
# Azure Identity & Subscription
# ─────────────────────────────────────────────

variable "azure_subscription_id" {
  description = "Azure Subscription ID where the Fabric Capacity lives."
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure / Entra ID Tenant ID."
  type        = string
}

variable "spn_client_id" {
  description = "Service Principal (App Registration) Client ID used to authenticate Terraform providers."
  type        = string
  sensitive   = true
}

variable "spn_client_secret" {
  description = "Service Principal Client Secret."
  type        = string
  sensitive   = true
}

# ─────────────────────────────────────────────
# Environment & Naming
# ─────────────────────────────────────────────

variable "environment" {
  description = "Deployment environment label (demo, dev, staging, prod)."
  type        = string
  default     = "demo"

  validation {
    condition     = contains(["demo", "dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: demo, dev, staging, prod."
  }
}

variable "project_name" {
  description = "Short project / initiative name used in resource naming (lowercase, no spaces)."
  type        = string
  default     = "medallion"
}

variable "location" {
  description = "Azure region for the Fabric Capacity resource."
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Common tags applied to all Azure resources."
  type        = map(string)
  default = {
    managed_by  = "terraform"
    project     = "microsoft-fabric-medallion"
    environment = "demo"
  }
}

# ─────────────────────────────────────────────
# Fabric Capacity
# ─────────────────────────────────────────────

variable "capacity_sku" {
  description = "Microsoft Fabric capacity SKU. F64 = 64 Capacity Units (recommended for managed VNets, Copilot & trusted workspace ingestion)."
  type        = string
  default     = "F64"

  validation {
    condition     = can(regex("^F(2|4|8|16|32|64|128|256|512|1024|2048)$", var.capacity_sku))
    error_message = "capacity_sku must be a valid Fabric F-SKU (F2–F2048)."
  }
}

variable "capacity_admin_upns" {
  description = "List of Entra ID UPNs (user principal names) or object IDs to set as Fabric Capacity Administrators."
  type        = list(string)
  default     = []
}

# ─────────────────────────────────────────────
# Medallion Workspace Configuration
# ─────────────────────────────────────────────

variable "workspace_admins" {
  description = "List of Entra ID user/group object IDs to assign the Admin role on all three workspaces."
  type        = list(string)
  default     = []
}

variable "workspace_contributors" {
  description = "List of Entra ID user/group object IDs to assign the Contributor role on Silver & Gold workspaces."
  type        = list(string)
  default     = []
}

variable "workspace_viewers" {
  description = "List of Entra ID user/group object IDs to assign the Viewer role on the Gold workspace."
  type        = list(string)
  default     = []
}

variable "enable_git_integration" {
  description = "Whether to output workspace IDs that can be wired up to Azure DevOps / GitHub git integration post-deploy."
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────
# Lakehouse Options
# ─────────────────────────────────────────────

variable "enable_schemas" {
  description = "Enable lakehouse schemas (requires Fabric preview feature). Set to false for GA-only deployments."
  type        = bool
  default     = false
}
