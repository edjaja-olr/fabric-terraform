variable "layer" {
  description = "Medallion layer label (bronze | silver | gold). Used for identification only."
  type        = string
}

variable "display_name" {
  description = "Workspace display name visible in the Fabric portal."
  type        = string
}

variable "description" {
  description = "Human-readable description for the workspace."
  type        = string
  default     = ""
}

variable "capacity_id" {
  description = "Fabric Capacity ARM resource ID to assign this workspace to."
  type        = string
}
