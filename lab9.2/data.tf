data "azurerm_key_vault" "kv01" {
  name                = "cherriKey609162"
  resource_group_name = "charanrg"
}
data "azurerm_key_vault_secret" "sec01" {
  name         = "admin-password"
  key_vault_id = data.azurerm_key_vault.kv01.id
}