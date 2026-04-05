variable "workspace_id" {
  description = "Fabric Workspace GUID where the Lakehouse is created."
  type        = string
}

variable "lakehouse_name" {
  description = "Display name for the Lakehouse."
  type        = string
}

variable "enable_schemas" {
  description = "Enable the Lakehouse schema feature (Fabric preview). Defaults to false."
  type        = bool
  default     = false
}
