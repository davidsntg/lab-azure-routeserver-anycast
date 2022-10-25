#########################################################
# Region 1 Hub VNet
#########################################################
resource "azurerm_virtual_network" "region1-hub-vnet" {
  name                = "region1-hub-vnet"
  location            = azurerm_resource_group.azure-region1-rg.location
  resource_group_name = azurerm_resource_group.azure-region1-rg.name
  address_space       = ["10.1.0.0/21"]
 
}

resource "azurerm_subnet" "region1-hub-gateway-subnet" {
    name                    = "GatewaySubnet"
    resource_group_name     = azurerm_resource_group.azure-region1-rg.name
    virtual_network_name    = azurerm_virtual_network.region1-hub-vnet.name
    address_prefixes        = ["10.1.0.0/26"]
}


resource "azurerm_subnet" "region1-hub-workload-subnet" {
    name                    = "snet-workload"
    resource_group_name     = azurerm_resource_group.azure-region1-rg.name
    virtual_network_name    = azurerm_virtual_network.region1-hub-vnet.name
    address_prefixes        = ["10.1.0.64/26"]
}

/*resource "azurerm_subnet" "region1-hub-applicationgateway-subnet" {
    name                    = "snet-applicationgateway"
    resource_group_name     = azurerm_resource_group.azure-region1-rg.name
    virtual_network_name    = azurerm_virtual_network.region1-hub-vnett.name
    address_prefixes        = ["10.1.1.128/25"]
}*/

resource "azurerm_subnet" "region1-hub-routeserver-subnet" {
    name                    = "RouteServerSubnet"
    resource_group_name     = azurerm_resource_group.azure-region1-rg.name
    virtual_network_name    = azurerm_virtual_network.region1-hub-vnet.name
    address_prefixes        = ["10.1.0.128/27"]
}

#########################################################
# Region 2 Hub VNet
#########################################################
resource "azurerm_virtual_network" "region2-hub-vnet" {
  name                = "region2-hub-vnet"
  location            = azurerm_resource_group.azure-region2-rg.location
  resource_group_name = azurerm_resource_group.azure-region2-rg.name
  address_space       = ["10.2.0.0/21"]
 
}

resource "azurerm_subnet" "region2-hub-gateway-subnet" {
    name                    = "GatewaySubnet"
    resource_group_name     = azurerm_resource_group.azure-region2-rg.name
    virtual_network_name    = azurerm_virtual_network.region2-hub-vnet.name
    address_prefixes        = ["10.2.0.0/26"]
}


resource "azurerm_subnet" "region2-hub-workload-subnet" {
    name                    = "snet-workload"
    resource_group_name     = azurerm_resource_group.azure-region2-rg.name
    virtual_network_name    = azurerm_virtual_network.region2-hub-vnet.name
    address_prefixes        = ["10.2.0.64/26"]
}

/*resource "azurerm_subnet" "region2-hub-applicationgateway-subnet" {
    name                    = "snet-applicationgateway"
    resource_group_name     = azurerm_resource_group.azure-region2-rg.name
    virtual_network_name    = azurerm_virtual_network.region2-hub-vnett.name
    address_prefixes        = ["10.221.1.128/25"]
}*/

resource "azurerm_subnet" "region2-hub-routeserver-subnet" {
    name                    = "RouteServerSubnet"
    resource_group_name     = azurerm_resource_group.azure-region2-rg.name
    virtual_network_name    = azurerm_virtual_network.region2-hub-vnet.name
    address_prefixes        = ["10.2.0.128/27"]
}

#########################################################
# Onprem 
#########################################################

resource "azurerm_virtual_network" "onprem-vnet" {
  name                = "onprem-vnet"
  location            = azurerm_resource_group.onprem-rg.location
  resource_group_name = azurerm_resource_group.onprem-rg.name
  address_space       = ["10.0.0.0/21"]
  
}

resource "azurerm_subnet" "onprem-gateway-subnet" {
    name                    = "GatewaySubnet"
    resource_group_name     = azurerm_resource_group.onprem-rg.name
    virtual_network_name    = azurerm_virtual_network.onprem-vnet.name
    address_prefixes        = ["10.0.0.0/26"]
}

resource "azurerm_subnet" "onprem-workload-subnet" {
    name                    = "snet-workload"
    resource_group_name     = azurerm_resource_group.onprem-rg.name
    virtual_network_name    = azurerm_virtual_network.onprem-vnet.name
    address_prefixes        = ["10.0.0.64/26"]
}

