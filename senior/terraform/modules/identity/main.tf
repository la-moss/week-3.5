resource "azurerm_user_assigned_identity" "uai" {
  name                = var.name
  location            = "westeurope"
  resource_group_name = "rg-shared-identity"
  tags                = var.tags
}

resource "azurerm_role_definition" "automation" {
  name        = "${var.name}-role"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Automation role for platform operations."

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}"
  ]

  permissions {
    actions = [
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.KeyVault/secrets/delete",
      "Microsoft.KeyVault/vaults/delete"
    ]
  }
}

resource "azurerm_role_assignment" "automation_custom" {
  scope              = "/subscriptions/${var.subscription_id}"
  role_definition_id = azurerm_role_definition.automation.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.uai.principal_id
}

resource "azurerm_role_assignment" "automation_admin" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  for_each             = toset(var.keyvault_ids)
  scope                = each.value
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}
