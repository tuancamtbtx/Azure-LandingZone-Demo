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