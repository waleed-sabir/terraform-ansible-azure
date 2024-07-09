terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.111.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfStateFile-rg" # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "remotetfstatefile"  # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tf-state" # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "terraform.tfstate"  # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

# Resource group config

variable "rg-location" {
  description = "Location/Region of the resource group"
  type = string
}

variable "rg-name" {
  description = "Name of the resource group"
  type = string
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.rg-name
  location = var.rg-location
}

# Virtual network config

variable "vnet-name" {
  description = "Name of the virtual network"
  type = string
}

variable "vnet-cidr-block" {
  description = "CIDR block for virtual network"
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet-name
  address_space       = var.vnet-cidr-block
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

# Subnet config

variable "subnet1-name" {
  description = "Name of the subnet"
  type = string
}

variable "subnet1-cidr-block" {
  description = "CIDR block of the subnet"
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1-name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.subnet1-cidr-block
}

# Network Interface config

variable "nic-name" {
  description = "Name of the network interface"
  type = string
}

variable "nic-ip-config-name" {
  description = "Name of IP configuration of the network interface"
}

resource "azurerm_network_interface" "network_interface" {
  name                = var.nic-name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = var.nic-ip-config-name
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Public IP config

variable "public-ip-name" {
  description = "Name of the public IP"
  type = string
}
resource "azurerm_public_ip" "public_ip" {
  name                = var.public-ip-name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"
}

# Network Security Group (NSG) config

variable "nsg-name" {
  description = "Name of the network security group"
  type = string
}

# Rule 1 config

variable "security-rule-name" {
  description = "Name of the security rule"
  type = string
}

variable "security-rule-priority" {
  description = "Priority value of the security rule"
  type = string
}

variable "security-rule-direction" {
  description = "Direction of the security rule"
  type = string
}

variable "security-rule-access" {
  description = "Access type of the security rule"
  type = string
}

variable "security-rule-protocol" {
  description = "Protocol of the security rule"
  type = string
}

variable "security-rule-source-port-range" {
  description = "Source port range of the security rule"
  type = string
}

variable "security-rule-destination-port-range" {
  description = "Destination port range of the security rule"
  type = string
}

variable "security-rule-source-addr-prefix" {
  description = "Source address prefix of the security rule"
  type = string
}

variable "security-rule-destination-addr-prefix" {
  description = "Destination address prefix of the security rule"
  type = string
}

# Rule 2 config

variable "security-rule2-name" {
  description = "Name of the security rule 2"
}

variable "security-rule2-priority" {
  description = "Priority value of the security rule 2"
}

variable "security-rule2-destination-port-range" {
  description = "Destination port range of the security rule 2"
}



resource "azurerm_network_security_group" "network_security_group" {
  name                = var.nsg-name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = var.security-rule-name
    priority                   = var.security-rule-priority
    direction                  = var.security-rule-direction
    access                     = var.security-rule-access
    protocol                   = var.security-rule-protocol
    source_port_range          = var.security-rule-source-port-range
    destination_port_range     = var.security-rule-destination-port-range
    source_address_prefix      = var.security-rule-source-addr-prefix
    destination_address_prefix = var.security-rule-destination-addr-prefix
  }
  
  security_rule {
    name                       = var.security-rule2-name
    priority                   = var.security-rule2-priority
    direction                  = var.security-rule-direction
    access                     = var.security-rule-access
    protocol                   = var.security-rule-protocol
    source_port_range          = var.security-rule-source-port-range
    destination_port_range     = var.security-rule2-destination-port-range
    source_address_prefix      = var.security-rule-source-addr-prefix
    destination_address_prefix = var.security-rule-destination-addr-prefix
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}


# Virtual Machine (VM) config

variable "vm-name" {
  description = "Name of the virtual machine"
  type = string  
}

variable "vm-size" {
  description = "Size of the virtual machine"
  type = string  
}

variable "admin-user" {
  description = "Name of the admin user"
  type = string
}

variable "ssh-adminuser" {
  description = "Name of the SSH admin user"
  type = string
}

variable "public-key-path" {
  description = "Path to the public key"
}

variable "disk-caching" {
  description = "Type of disk caching"
}

variable "storage-account-type" {
  description = "Type of the storage account"
}

variable "disk-size" {
  description = "Size of the disk in GB"
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                = var.vm-name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  size                = var.vm-size
  admin_username      = var.admin-user
  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  admin_ssh_key {
    username   = var.ssh-adminuser
    public_key = file(var.public-key-path)
  }

  os_disk {
    caching              = var.disk-caching
    storage_account_type = var.storage-account-type
    disk_size_gb = var.disk-size
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

output "vm-publicIP" {
  description = "Public IP of the virtual machine"
  value = azurerm_linux_virtual_machine.virtual_machine.public_ip_address
}