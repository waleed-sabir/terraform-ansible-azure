# Resource Group
variable "rg-location" {
  description = "Location/Region of the resource group"
  type = string
}

variable "rg-name" {
  description = "Name of the resource group"
  type = string
}

# Virtual Network
variable "vnet-name" {
  description = "Name of the virtual network"
  type = string
}

variable "vnet-cidr-block" {
  description = "CIDR block for virtual network"
}

# Subnet
variable "subnet1-name" {
  description = "Name of the subnet"
  type = string
}

variable "subnet1-cidr-block" {
  description = "CIDR block of the subnet"
}

# Network Interface
variable "nic-name" {
  description = "Name of the network interface"
  type = string
}

variable "nic-ip-config-name" {
  description = "Name of IP configuration of the network interface"
}

# Public IP
variable "public-ip-name" {
  description = "Name of the public IP"
  type = string
}

# Network Security Group 
variable "nsg-name" {
  description = "Name of the network security group"
  type = string
}
# NSG Security Rule(s)
# Rule 1
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

# Rule 2
variable "security-rule2-name" {
  description = "Name of the security rule 2"
}

variable "security-rule2-priority" {
  description = "Priority value of the security rule 2"
}

variable "security-rule2-destination-port-range" {
  description = "Destination port range of the security rule 2"
}

# Virtual Machine
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

# Provisioner
variable "private-key-location" {
  description = "Path of the private key"
}

variable "ansible-user" {
  description = "Name of the Ansible user"
}