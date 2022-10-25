
# Region 1 Hub Route Server

resource "azurerm_public_ip" "region1-hub-routeserver-pip" {
  name                = "region1-RouteServer-pip"
  resource_group_name = azurerm_resource_group.azure-region1-rg.name
  location            = azurerm_resource_group.azure-region1-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_route_server" "region1-hub-routeserver" {
  name                             = "region1-RouteServer"
  resource_group_name              = azurerm_resource_group.azure-region1-rg.name
  location                         = azurerm_resource_group.azure-region1-rg.location
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.region1-hub-routeserver-pip.id
  subnet_id                        = azurerm_subnet.region1-hub-routeserver-subnet.id
  branch_to_branch_traffic_enabled = true
}

resource "azurerm_route_server_bgp_connection" "region1-hub-rs-peering-nva" {
  name            = "BgpPeering-NVA-region1"
  route_server_id = azurerm_route_server.region1-hub-routeserver.id
  peer_asn        = 65010
  peer_ip         = "10.1.0.69"
}

# Region 2 Hub Route Server

resource "azurerm_public_ip" "region2-hub-routeserver-pip" {
  name                = "region2-RouteServer-pip"
  resource_group_name = azurerm_resource_group.azure-region2-rg.name
  location            = azurerm_resource_group.azure-region2-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_route_server" "region2-hub-routeserver" {
  name                             = "region2-RouteServer"
  resource_group_name              = azurerm_resource_group.azure-region2-rg.name
  location                         = azurerm_resource_group.azure-region2-rg.location
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.region2-hub-routeserver-pip.id
  subnet_id                        = azurerm_subnet.region2-hub-routeserver-subnet.id
  branch_to_branch_traffic_enabled = true
}

resource "azurerm_route_server_bgp_connection" "region2-hub-rs-peering-nva" {
  name            = "BgpPeering-NVA-region2"
  route_server_id = azurerm_route_server.region2-hub-routeserver.id
  peer_asn        = 65010
  peer_ip         = "10.2.0.69"
}