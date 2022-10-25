#########################################################
# Region 1 Hub VPN Gateway
#########################################################

resource "azurerm_public_ip" "region1-hub-vpngw-pip1" {
  name                = "region1-hub-vpngw-pip1"
  location            = azurerm_resource_group.azure-region1-rg.location
  resource_group_name = azurerm_resource_group.azure-region1-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_public_ip" "region1-hub-vpngw-pip2" {
  name                = "region1-hub-vpngw-pip2"
  location            = azurerm_resource_group.azure-region1-rg.location
  resource_group_name = azurerm_resource_group.azure-region1-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_virtual_network_gateway" "region1-hub-vpngw" {
  name                              = "region1-hub-vpngw"
  location                          = azurerm_resource_group.azure-region1-rg.location
  resource_group_name               = azurerm_resource_group.azure-region1-rg.name

  type                              = "Vpn"
  vpn_type                          = "RouteBased"

  active_active                     = true
  enable_bgp                        = true
  sku                               = "VpnGw1"

  bgp_settings {
      asn = var.azure_bgp_asn_region1
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig1"
    public_ip_address_id            = azurerm_public_ip.region1-hub-vpngw-pip1.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.region1-hub-gateway-subnet.id
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig2"
    public_ip_address_id            = azurerm_public_ip.region1-hub-vpngw-pip2.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.region1-hub-gateway-subnet.id
  }

}

#########################################################
# Region 2 Hub VPN Gateway
#########################################################

resource "azurerm_public_ip" "region2-hub-vpngw-pip1" {
  name                = "region2-hub-vpngw-pip1"
  location            = azurerm_resource_group.azure-region2-rg.location
  resource_group_name = azurerm_resource_group.azure-region2-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_public_ip" "region2-hub-vpngw-pip2" {
  name                = "region2-hub-vpngw-pip2"
  location            = azurerm_resource_group.azure-region2-rg.location
  resource_group_name = azurerm_resource_group.azure-region2-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_virtual_network_gateway" "region2-hub-vpngw" {
  name                              = "region2-hub-vpngw"
  location                          = azurerm_resource_group.azure-region2-rg.location
  resource_group_name               = azurerm_resource_group.azure-region2-rg.name

  type                              = "Vpn"
  vpn_type                          = "RouteBased"

  active_active                     = true
  enable_bgp                        = true
  sku                               = "VpnGw1"

  bgp_settings {
      asn = var.azure_bgp_asn_region2
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig1"
    public_ip_address_id            = azurerm_public_ip.region2-hub-vpngw-pip1.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.region2-hub-gateway-subnet.id
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig2"
    public_ip_address_id            = azurerm_public_ip.region2-hub-vpngw-pip2.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.region2-hub-gateway-subnet.id
  }

}

#########################################################
# On premise VPN Gateway
#########################################################

resource "azurerm_public_ip" "onprem-vpngw-pip1" {
  name                = "onprem-vpngw-pip1"
  location            = azurerm_resource_group.onprem-rg.location
  resource_group_name = azurerm_resource_group.onprem-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_public_ip" "onprem-vpngw-pip2" {
  name                = "onprem-vpngw-pip2"
  location            = azurerm_resource_group.onprem-rg.location
  resource_group_name = azurerm_resource_group.onprem-rg.name

  allocation_method = "Dynamic"

}

resource "azurerm_virtual_network_gateway" "onprem-vpngw" {
  name                              = "onprem-vpngw"
  location                          = azurerm_resource_group.onprem-rg.location
  resource_group_name               = azurerm_resource_group.onprem-rg.name

  type                              = "Vpn"
  vpn_type                          = "RouteBased"

  active_active                     = true
  enable_bgp                        = true
  sku                               = "VpnGw1"

  bgp_settings {
      asn = var.onpremise_bgp_asn
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig1"
    public_ip_address_id            = azurerm_public_ip.onprem-vpngw-pip1.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.onprem-gateway-subnet.id
  }

  ip_configuration {
    name                            = "vnetGatewayIpConfig2"
    public_ip_address_id            = azurerm_public_ip.onprem-vpngw-pip2.id
    private_ip_address_allocation   = "Dynamic"
    subnet_id                       = azurerm_subnet.onprem-gateway-subnet.id
  }

}


#########################################################
# Onprem Local Network Gateways to Azure Region 1
#########################################################

resource "azurerm_local_network_gateway" "onprem-lng-to-azure-region1-pip1" {
  name                  = "onprem-lng-to-azure-region1-pip1"
  resource_group_name   = azurerm_resource_group.onprem-rg.name
  location              = azurerm_resource_group.onprem-rg.location
  gateway_address       = azurerm_public_ip.region1-hub-vpngw-pip1.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.region1-hub-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.region1-hub-vpngw.bgp_settings[0].peering_addresses[0].default_addresses[0]
      peer_weight         = azurerm_virtual_network_gateway.region1-hub-vpngw.bgp_settings[0].peer_weight
  }

  depends_on = [azurerm_virtual_network_gateway.region1-hub-vpngw]
}

resource "azurerm_local_network_gateway" "onprem-lng-to-azure-region1-pip2" {
  name                  = "onprem-lng-to-azure-region1-pip2"
  resource_group_name   = azurerm_resource_group.onprem-rg.name
  location              = azurerm_resource_group.onprem-rg.location
  gateway_address       = azurerm_public_ip.region1-hub-vpngw-pip2.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.region1-hub-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.region1-hub-vpngw.bgp_settings[0].peering_addresses[1].default_addresses[0]
      peer_weight         = azurerm_virtual_network_gateway.region1-hub-vpngw.bgp_settings[0].peer_weight
  }

  depends_on = [azurerm_virtual_network_gateway.region1-hub-vpngw]
}

#########################################################
# Onprem Local Network Gateway to Azure Region 2
#########################################################

resource "azurerm_local_network_gateway" "onprem-lng-to-azure-region2-pip1" {
  name                  = "onprem-lng-to-azure-region2-pip1"
  resource_group_name   = azurerm_resource_group.onprem-rg.name
  location              = azurerm_resource_group.onprem-rg.location
  gateway_address       = azurerm_public_ip.region2-hub-vpngw-pip1.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.region2-hub-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.region2-hub-vpngw.bgp_settings[0].peering_addresses[0].default_addresses[0]
      peer_weight         = azurerm_virtual_network_gateway.region2-hub-vpngw.bgp_settings[0].peer_weight
  }

  depends_on = [azurerm_virtual_network_gateway.region2-hub-vpngw]
}

resource "azurerm_local_network_gateway" "onprem-lng-to-azure-region2-pip2" {
  name                  = "onprem-lng-to-azure-region2-pip2"
  resource_group_name   = azurerm_resource_group.onprem-rg.name
  location              = azurerm_resource_group.onprem-rg.location
  gateway_address       = azurerm_public_ip.region2-hub-vpngw-pip2.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.region2-hub-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.region2-hub-vpngw.bgp_settings[0].peering_addresses[1].default_addresses[0]
      peer_weight         = azurerm_virtual_network_gateway.region2-hub-vpngw.bgp_settings[0].peer_weight
  }

  depends_on = [azurerm_virtual_network_gateway.region2-hub-vpngw]
}

#########################################################
# Azure Region 1 Local Network Gateway to On Premise
#########################################################

resource "azurerm_local_network_gateway" "region1-hub-lng-to-onpremise-pip1" {
  name                  = "region1-hub-lng-to-onpremise-pip1"
  resource_group_name   = azurerm_resource_group.azure-region1-rg.name
  location              = azurerm_resource_group.azure-region1-rg.location
  gateway_address       = azurerm_public_ip.onprem-vpngw-pip1.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.onprem-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.onprem-vpngw.bgp_settings[0].peering_addresses[0].default_addresses[0]
  }

  depends_on = [azurerm_virtual_network_gateway.onprem-vpngw]
}

resource "azurerm_local_network_gateway" "region1-hub-lng-to-onpremise-pip2" {
  name                  = "region1-hub-lng-to-onpremise-pip2"
  resource_group_name   = azurerm_resource_group.azure-region1-rg.name
  location              = azurerm_resource_group.azure-region1-rg.location
  gateway_address       = azurerm_public_ip.onprem-vpngw-pip2.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.onprem-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.onprem-vpngw.bgp_settings[0].peering_addresses[1].default_addresses[0]
  }

  depends_on = [azurerm_virtual_network_gateway.onprem-vpngw]
}

#########################################################
# Azure Region 1 Local Network Gateway to On Premise
#########################################################

resource "azurerm_local_network_gateway" "region2-hub-lng-to-onpremise-pip1" {
  name                  = "region2-hub-lng-to-onpremise-pip1"
  resource_group_name   = azurerm_resource_group.azure-region2-rg.name
  location              = azurerm_resource_group.azure-region2-rg.location
  gateway_address       = azurerm_public_ip.onprem-vpngw-pip1.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.onprem-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.onprem-vpngw.bgp_settings[0].peering_addresses[0].default_addresses[0]
  }

  depends_on = [azurerm_virtual_network_gateway.onprem-vpngw]
}

resource "azurerm_local_network_gateway" "region2-hub-lng-to-onpremise-pip2" {
  name                  = "region2-hub-lng-to-onpremise-pip2"
  resource_group_name   = azurerm_resource_group.azure-region2-rg.name
  location              = azurerm_resource_group.azure-region2-rg.location
  gateway_address       = azurerm_public_ip.onprem-vpngw-pip2.ip_address
  
  bgp_settings  {
      asn                    = azurerm_virtual_network_gateway.onprem-vpngw.bgp_settings[0].asn
      bgp_peering_address    = azurerm_virtual_network_gateway.onprem-vpngw.bgp_settings[0].peering_addresses[1].default_addresses[0]
  }

  depends_on = [azurerm_virtual_network_gateway.onprem-vpngw]
}


#########################################################
# Connection Azure Region 1 => On premise 
#########################################################
resource "azurerm_virtual_network_gateway_connection" "region1-hub-to-onpremise-pip1" {
  name                = "${azurerm_virtual_network_gateway.region1-hub-vpngw.name}-To-${azurerm_virtual_network_gateway.onprem-vpngw.name}_pip1"
  resource_group_name   = azurerm_resource_group.azure-region1-rg.name
  location              = azurerm_resource_group.azure-region1-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.region1-hub-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.region1-hub-lng-to-onpremise-pip1.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.region1-hub-vpngw, azurerm_local_network_gateway.region1-hub-lng-to-onpremise-pip1]
}

resource "azurerm_virtual_network_gateway_connection" "region1-hub-to-onpremise-pip2" {
  name                = "${azurerm_virtual_network_gateway.region1-hub-vpngw.name}-To-${azurerm_virtual_network_gateway.onprem-vpngw.name}_pip2"
  resource_group_name   = azurerm_resource_group.azure-region1-rg.name
  location              = azurerm_resource_group.azure-region1-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.region1-hub-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.region1-hub-lng-to-onpremise-pip2.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.region1-hub-vpngw, azurerm_local_network_gateway.region1-hub-lng-to-onpremise-pip2]
}

#########################################################
# Connection Azure Region 2 => On premise 
#########################################################

resource "azurerm_virtual_network_gateway_connection" "region2-hub-to-onpremise-pip1" {
  name                = "${azurerm_virtual_network_gateway.region2-hub-vpngw.name}-To-${azurerm_virtual_network_gateway.onprem-vpngw.name}_pip1"
  resource_group_name   = azurerm_resource_group.azure-region2-rg.name
  location              = azurerm_resource_group.azure-region2-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.region2-hub-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.region2-hub-lng-to-onpremise-pip1.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.region2-hub-vpngw, azurerm_local_network_gateway.region2-hub-lng-to-onpremise-pip1]
}

resource "azurerm_virtual_network_gateway_connection" "region2-hub-to-onpremise-pip2" {
  name                = "${azurerm_virtual_network_gateway.region2-hub-vpngw.name}-To-${azurerm_virtual_network_gateway.onprem-vpngw.name}_pip2"
  resource_group_name   = azurerm_resource_group.azure-region2-rg.name
  location              = azurerm_resource_group.azure-region2-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.region2-hub-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.region2-hub-lng-to-onpremise-pip2.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.region2-hub-vpngw, azurerm_local_network_gateway.region2-hub-lng-to-onpremise-pip2]
}

#########################################################
# Connection On premise => Azure Region 1 
#########################################################

resource "azurerm_virtual_network_gateway_connection" "onpremise-to-azure-hub-region1-pip1" {
  name                = "${azurerm_virtual_network_gateway.onprem-vpngw.name}-To-${azurerm_virtual_network_gateway.region1-hub-vpngw.name}_pip1"
  resource_group_name   = azurerm_resource_group.onprem-rg.name
  location              = azurerm_resource_group.onprem-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem-lng-to-azure-region1-pip1.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.onprem-vpngw, azurerm_local_network_gateway.onprem-lng-to-azure-region1-pip1]
}

resource "azurerm_virtual_network_gateway_connection" "onpremise-to-azure-hub-region1-pip2" {
  name                = "${azurerm_virtual_network_gateway.onprem-vpngw.name}-To-${azurerm_virtual_network_gateway.region1-hub-vpngw.name}_pip2"
  resource_group_name   = azurerm_resource_group.onprem-rg.name
  location              = azurerm_resource_group.onprem-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem-lng-to-azure-region1-pip2.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.onprem-vpngw, azurerm_local_network_gateway.onprem-lng-to-azure-region1-pip2]
}

#########################################################
# Connection On premise => Azure Region 1 
#########################################################

resource "azurerm_virtual_network_gateway_connection" "onpremise-to-azure-hub-region2-pip1" {
  name                = "${azurerm_virtual_network_gateway.onprem-vpngw.name}-To-${azurerm_virtual_network_gateway.region2-hub-vpngw.name}_pip1"
  resource_group_name   = azurerm_resource_group.onprem-rg.name
  location              = azurerm_resource_group.onprem-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem-lng-to-azure-region2-pip1.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.onprem-vpngw, azurerm_local_network_gateway.onprem-lng-to-azure-region2-pip1]
}

resource "azurerm_virtual_network_gateway_connection" "onpremise-to-azure-hub-region2-pip2" {
  name                = "${azurerm_virtual_network_gateway.onprem-vpngw.name}-To-${azurerm_virtual_network_gateway.region2-hub-vpngw.name}_pip2"
  resource_group_name   = azurerm_resource_group.onprem-rg.name
  location              = azurerm_resource_group.onprem-rg.location

  type                       = "IPsec"
  enable_bgp                 = true
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem-vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem-lng-to-azure-region2-pip2.id

  shared_key = local.shared-key

  depends_on = [azurerm_virtual_network_gateway.onprem-vpngw, azurerm_local_network_gateway.onprem-lng-to-azure-region2-pip2]
}
