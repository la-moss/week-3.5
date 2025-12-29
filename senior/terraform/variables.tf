variable "subscription_id" {
  type        = string
  description = "Target subscription ID."
}

variable "tenant_id" {
  type        = string
  description = "AAD tenant ID."
}

variable "prefix" {
  type        = string
  description = "Resource name prefix."
  default     = "iaclab"
}

variable "environment" {
  type        = string
  description = "Environment name."
  default     = "prod"
}

variable "primary_location" {
  type        = string
  description = "Primary region."
  default     = "westeurope"
}

variable "secondary_location" {
  type        = string
  description = "Secondary region."
  default     = "northeurope"
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default = {
    Owner      = "platform"
    CostCenter = "cc-042"
    Env        = "prod"
  }
}
