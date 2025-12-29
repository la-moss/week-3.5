resource "random_password" "secret" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault" "kv" {
  name                       = var.name
  location                   = var.rg_location
  resource_group_name        = var.rg_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 14
  enable_rbac_authorization  = true
  tags                       = var.tags
}

resource "azurerm_key_vault_secret" "demo" {
  name         = "bootstrap"
  value        = random_password.secret.result
  key_vault_id = azurerm_key_vault.kv.id
}
