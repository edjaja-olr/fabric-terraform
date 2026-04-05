variable "workspace_ids" {
  description = "Map of medallion layer name → Fabric Workspace GUID."
  type        = map(string)
}

variable "admin_principals" {
  description = "Entra ID object IDs for principals to receive the Admin role on all workspaces."
  type        = list(string)
  default     = []
}

variable "contributor_principals" {
  description = "Entra ID object IDs for principals to receive the Contributor role on Silver & Gold workspaces."
  type        = list(string)
  default     = []
}

variable "viewer_principals" {
  description = "Entra ID object IDs for principals to receive the Viewer role on the Gold workspace only."
  type        = list(string)
  default     = []
}
