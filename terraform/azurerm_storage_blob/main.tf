terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.80.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}


resource "azurerm_resource_group" "datalake_rg" {
  name     = "datalake_rg"
  location = "Southeast Asia"
}
resource "azurerm_virtual_network" "datalake_vnet" {
  name                = "tuan-test-virtnetname"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.datalake_rg.location
  resource_group_name = azurerm_resource_group.datalake_rg.name
}
resource "azurerm_subnet" "datalake_subnet" {
  name                 = "tuan-test-subnetname"
  resource_group_name  = azurerm_resource_group.datalake_rg.name
  virtual_network_name = azurerm_virtual_network.datalake_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}
resource "azurerm_storage_account" "datalake_storage_account" {
  name                     = "tuan-test-storageaccount-cdc"
  resource_group_name      = azurerm_resource_group.datalake_rg.name
  location                 = azurerm_resource_group.datalake_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    # ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.datalake_subnet.id]
  }
  tags {
    eviroment = "dev"
  }
}
# resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
#   name               = "example"
#   storage_account_id = azurerm_storage_account.example.id
# }
# resource "azurerm_storage_data_lake_gen2_path" "example" {
#   path               = "example"
#   filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.example.name
#   storage_account_id = azurerm_storage_account.example.id
#   resource           = "directory"
# }