#########################################################
# Variables
#########################################################

variable "azure_location1" {
  type = string
  default = "westeurope"
  description = "Azure resources location"
}

variable "azure_location2" {
  type = string
  default = "northeurope"
  description = "Azure resources location"
}

variable "onpremise_location" {
  type = string
  default = "eastus"
  description = "Azure resources location"
}

variable "admin_username" {
    description = ""
    type = string
    default = "adminuser"
}

variable "admin_password" {
  description = "Password for all VMs deployed in this MicroHack"
  type        = string
  default = "Microsoft=1Microsoft=1"
}

variable "vm_size" {
  type = string
  default = "Standard_DS1_v2"
  description = "VM Size"
}

variable "vm_os_type" {
  type = string
  default = "Linux"
  description = "VM OS Type"
}

variable "vm_os_publisher" {
  type = string
  default = "canonical"
  description = "VM OS Publisher"
}

variable "vm_os_offer" {
  type = string
  #default = "UbuntuServer"
  default = "0001-com-ubuntu-server-jammy"
  description = "VM OS Offer"
}

variable "vm_os_sku" {
  type = string
  default = "22_04-lts-gen2"
  description = "VM OS Sku"
}

variable "vm_os_version" {
  type = string
  default = "latest"
  description = "VM OS Version"
}

variable "onpremise_bgp_asn" {
    type = number
    default = 60000
    description = "On-premise Site2 BGP ASN"
}

variable "azure_bgp_asn_region1" {
    type = number
    default = 61000
    description = "Azure BGP ASN"
}

variable "azure_bgp_asn_region2" {
    type = number
    default = 61000
    description = "Azure BGP ASN"
}

#########################################################
# Locals
#########################################################

locals {
  shared-key = "microhack-shared-key"
}

#######################
# Application Gateway #
#######################

variable "backend_address_pool_name" {
    default = "myBackendPool"
}

variable "frontend_port_name" {
    default = "myFrontendPort"
}

variable "frontend_ip_configuration_private_name" {
    default = "myAGIPConfig-private"
}

variable "frontend_ip_configuration_public_name" {
    default = "myAGIPConfig-public"
}

variable "http_setting_name" {
    default = "myHTTPsetting"
}

variable "listener_name" {
    default = "myListener"
}

variable "request_routing_rule_name" {
    default = "myRoutingRule"
}

variable "redirect_configuration_name" {
    default = "myRedirectConfig"
}

locals {
  custom_data = <<CUSTOM_DATA
  #cloud-config
  package_upgrade: true
  packages:
    - apache2
  runcmd:
    - echo "Hello World from $(hostname)" > /var/www/html/index.html
    - systemctl enable apache2
    - systemctl start apache2
    - wget https://raw.githubusercontent.com/dmauser/azure-vm-net-tools/main/script/nettools.sh
    - chmod +x nettools.sh
    - ./nettools.sh
  CUSTOM_DATA

  nva1_data = <<CUSTOM_DATA
  #cloud-config
  package_upgrade: true
  packages:
    - exabgp 
    - haproxy 
    - net-tools
  write_files:
    - owner: root:root
      path: /tmp/confexabgp.ini
      content: |
        neighbor 10.1.0.132 {
          router-id 10.1.0.69;
          local-address 10.1.0.69;
          local-as 65010;
          peer-as 65515;
          static {
          route 9.9.9.9/32 next-hop 10.1.0.69 as-path [];
          }
        }
        neighbor 10.1.0.133 {
          router-id 10.1.0.69;
          local-address 10.1.0.69;
          local-as 65010;
          peer-as 65515;
          static {
          route 9.9.9.9/32 next-hop 10.1.0.69;
          }
        }
    - owner: root:root
      path: /etc/haproxy/haproxy.cfg
      content: |
        frontend http_front
          bind *:80
          stats uri /haproxy?stats
          default_backend http_back
        backend http_back
          balance roundrobin
          server backend01 10.1.0.68:80 check
  runcmd:
    - ifconfig lo:9 9.9.9.9 netmask 255.255.255.255 up
    - systemctl restart haproxy
    - exabgp /tmp/confexabgp.ini
  CUSTOM_DATA

  nva2_data = <<CUSTOM_DATA
  #cloud-config
  package_upgrade: true
  packages:
    - exabgp
    - haproxy
    - net-tools
  write_files:
    - owner: root:root
      path: /tmp/confexabgp.ini
      content: |
        neighbor 10.2.0.132 {
          router-id 10.2.0.69;
          local-address 10.2.0.69;
          local-as 65010;
          peer-as 65515;
          static {
          route 9.9.9.9/32 next-hop 10.2.0.69 as-path [ 65010 65010 65010 ];
          }
        }
        neighbor 10.2.0.133 {
          router-id 10.2.0.69;
          local-address 10.2.0.69;
          local-as 65010;
          peer-as 65515;
          static {
          route 9.9.9.9/32 next-hop 10.2.0.69 as-path [ 65010 65010 65010 ];
          }
        }
    - owner: root:root
      path: /etc/haproxy/haproxy.cfg
      content: |
        frontend http_front
          bind *:80
          stats uri /haproxy?stats
          default_backend http_back
        backend http_back
          balance roundrobin
          server backend01 10.2.0.68:80 check
  runcmd:
    - ifconfig lo:9 9.9.9.9 netmask 255.255.255.255 up
    - systemctl restart haproxy
    - exabgp /tmp/confexabgp.ini
  CUSTOM_DATA
}

