provider "azurerm" {
  features {}
  
}

##################
# Resource Group #
##################

resource "azurerm_resource_group" "onprem-rg" {
  name     = "onprem-rg"
  location = var.onpremise_location

}

resource "azurerm_resource_group" "azure-region1-rg" {
  name     = "azure-region1-rg"
  location = var.azure_location1
}

resource "azurerm_resource_group" "azure-region2-rg" {
  name     = "azure-region2-rg"
  location = var.azure_location2
}