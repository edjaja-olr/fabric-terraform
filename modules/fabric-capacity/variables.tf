variable "resource_group_name" {
  description = "Azure Resource Group where the Fabric Capacity is created."
  type        = string
}

variable "location" {
  description = "Azure region for the Fabric Capacity."
  type        = string
}

variable "capacity_name" {
  description = "Name for the Fabric Capacity resource (lowercase, no hyphens, 3-63 chars)."
  type        = string
}

variable "sku" {
  description = "Fabric capacity SKU (e.g. F64)."
  type        = string
  default     = "F64"
}

variable "admin_members" {
  description = "List of Entra ID UPNs or object IDs granted Capacity Admin rights."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
