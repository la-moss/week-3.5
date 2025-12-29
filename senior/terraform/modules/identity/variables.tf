variable "name" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "keyvault_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
