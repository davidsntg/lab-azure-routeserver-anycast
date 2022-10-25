#########################################################
# Azure Region 1 Hub VMs
#########################################################

# Webapp VM
resource "azurerm_network_interface" "region1-webapp-vm-nic" {
  name                = "region1-webapp-vm-ni01"
  location            = azurerm_resource_group.azure-region1-rg.location
  resource_group_name = azurerm_resource_group.azure-region1-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.region1-hub-workload-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.68"
  }
}

resource "azurerm_linux_virtual_machine" "region1-webapp-vm" {
  name                              = "region1-webapp-vm"
  resource_group_name               = azurerm_resource_group.azure-region1-rg.name
  location                          = azurerm_resource_group.azure-region1-rg.location
  size                              = var.vm_size
  admin_username                    = var.admin_username
  disable_password_authentication   = "false"
  admin_password                    = var.admin_password
  network_interface_ids             = [azurerm_network_interface.region1-webapp-vm-nic.id]
  custom_data                       = base64encode(local.custom_data)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "region1-webapp-vm-od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

}

# NVA VM
resource "azurerm_network_interface" "region1-nva-vm-nic" {
  name                 = "region1-nva-vm-ni01"
  location             = azurerm_resource_group.azure-region1-rg.location
  resource_group_name  = azurerm_resource_group.azure-region1-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.region1-hub-workload-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.69"
  }
}

resource "azurerm_linux_virtual_machine" "region1-nva-vm" {
  name                              = "region1-nva-vm"
  resource_group_name               = azurerm_resource_group.azure-region1-rg.name
  location                          = azurerm_resource_group.azure-region1-rg.location
  size                              = var.vm_size
  admin_username                    = var.admin_username
  disable_password_authentication   = "false"
  admin_password                    = var.admin_password
  network_interface_ids             = [azurerm_network_interface.region1-nva-vm-nic.id]
  custom_data                       = base64encode(local.nva1_data)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "region1-nva-vm-od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }
}

#########################################################
# Azure Region 2 Hub VM
#########################################################

# Webapp
resource "azurerm_network_interface" "region2-webapp-vm-nic" {
  name                = "region2-webapp-vm-ni01"
  location            = azurerm_resource_group.azure-region2-rg.location
  resource_group_name = azurerm_resource_group.azure-region2-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.region2-hub-workload-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.0.68"
  }
}

resource "azurerm_linux_virtual_machine" "region2-webapp-vm" {
  name                              = "region2-webapp-vm"
  resource_group_name               = azurerm_resource_group.azure-region2-rg.name
  location                          = azurerm_resource_group.azure-region2-rg.location
  size                              = var.vm_size
  admin_username                    = var.admin_username
  disable_password_authentication   = "false"
  admin_password                    = var.admin_password
  network_interface_ids             = [azurerm_network_interface.region2-webapp-vm-nic.id]
  custom_data                       = base64encode(local.custom_data)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "region2-webapp-vm-od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }
}

# NVA VM
resource "azurerm_network_interface" "region2-nva-vm-nic" {
  name                = "region2-nva-vm-ni01"
  location            = azurerm_resource_group.azure-region2-rg.location
  resource_group_name = azurerm_resource_group.azure-region2-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.region2-hub-workload-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.2.0.69"
  }
}

resource "azurerm_linux_virtual_machine" "region2-nva-vm" {
  name                              = "region2-nva-vm"
  resource_group_name               = azurerm_resource_group.azure-region2-rg.name
  location                          = azurerm_resource_group.azure-region2-rg.location
  size                              = var.vm_size
  admin_username                    = var.admin_username
  disable_password_authentication   = "false"
  admin_password                    = var.admin_password
  network_interface_ids             = [azurerm_network_interface.region2-nva-vm-nic.id]
  custom_data                       = base64encode(local.nva2_data)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "region2-nva-vm-od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }
}

#########################################################
# Onpremise VM
#########################################################

resource "azurerm_network_interface" "onprem-vm-nic" {
  name                = "onprem-vm-ni01"
  location            = azurerm_resource_group.onprem-rg.location
  resource_group_name = azurerm_resource_group.onprem-rg.name

  ip_configuration {
    name                          = "ipConfig1"
    subnet_id                     = azurerm_subnet.onprem-workload-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_linux_virtual_machine" "onprem-vm" {
  name                              = "onprem-vm"
  resource_group_name               = azurerm_resource_group.onprem-rg.name
  location                          = azurerm_resource_group.onprem-rg.location
  size                              = var.vm_size
  admin_username                    = var.admin_username
  disable_password_authentication   = "false"
  admin_password                    = var.admin_password
  network_interface_ids             = [azurerm_network_interface.onprem-vm-nic.id]
  custom_data                       = base64encode(local.custom_data)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "onprem-vm-od01"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

}