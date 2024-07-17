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
resource "azurerm_resource_group" "resource_group" {
  name     = var.rg-name
  location = var.rg-location
}

# Virtual network config
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet-name
  address_space       = var.vnet-cidr-block
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

# Subnet config
resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1-name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.subnet1-cidr-block
}

# Network Interface config
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
resource "azurerm_public_ip" "public_ip" {
  name                = var.public-ip-name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"
}

# Network Security Group (NSG) config
resource "azurerm_network_security_group" "network_security_group" {
  name                = var.nsg-name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

# Rule 1 config
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
  
# Rule 2 config
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

# Provisioner config
  provisioner "local-exec" {
    command = "ansible-playbook --inventory ${self.public_ip_address}, --private-key ${var.private-key-location} --user ${var.ansible-user} playbook.yaml"
  }
}

output "vm-publicIP" {
  description = "Public IP of the virtual machine"
  value = azurerm_linux_virtual_machine.virtual_machine.public_ip_address
}