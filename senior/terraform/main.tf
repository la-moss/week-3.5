module "network_primary" {
  source   = "./modules/network"
  name     = "${local.name}-pri"
  location = var.primary_location
  tags     = var.tags
}

module "network_secondary" {
  source   = "./modules/network"
  name     = "${local.name}-sec"
  location = var.secondary_location
  tags     = var.tags

  providers = {
    azurerm = azurerm.secondary
  }
}

module "keyvault_primary" {
  source      = "./modules/keyvault"
  name        = "${local.name}-kv-pri"
  location    = var.primary_location
  tenant_id   = var.tenant_id
  rg_name     = module.network_primary.resource_group_name
  rg_location = module.network_primary.location
  tags        = var.tags
}

module "keyvault_secondary" {
  source      = "./modules/keyvault"
  name        = "${local.name}-kv-sec"
  location    = var.secondary_location
  tenant_id   = var.tenant_id
  rg_name     = module.network_secondary.resource_group_name
  rg_location = module.network_secondary.location
  tags        = var.tags

  providers = {
    azurerm = azurerm.secondary
  }
}

module "identity" {
  source          = "./modules/identity"
  name            = "${local.name}-auto"
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  keyvault_ids = [
    module.keyvault_primary.vault_id,
    module.keyvault_secondary.vault_id
  ]

  tags = var.tags
}
