output "automation_identity_principal_id" {
  value = module.identity.principal_id
}

output "primary_keyvault_id" {
  value = module.keyvault_primary.vault_id
}

output "secondary_keyvault_id" {
  value = module.keyvault_secondary.vault_id
}
