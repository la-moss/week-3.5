output "vault_id" {
  value = azurerm_key_vault.kv.id
}

output "secret_id" {
  value = azurerm_key_vault_secret.demo.id
}
