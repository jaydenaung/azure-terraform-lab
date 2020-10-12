resource "azurerm_resource_group" "sg_devops_vnet_rg" {
  name     = "sg_devops_vnet_rg"
  location = "Southeast Asia"
}

resource "azurerm_network_security_group" "sg_devops_sg" {
  name                = "devops_sg"
  location            = azurerm_resource_group.sg_devops_vnet_rg.location
  resource_group_name = azurerm_resource_group.sg_devops_vnet_rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  #security_rule {
  # name                       = "outbound_allow"
  # priority                   = 300
  # direction                  = "Outbound"
  # access                     = "Allow"
  #protocol                   = "*"
  #source_port_range          = "*"
  #destination_port_range     = "*"
  #source_address_prefix      = "*"
  #destination_address_prefix = "*"
  #}
}

resource "azurerm_network_ddos_protection_plan" "sg_devops_ddosplan1" {
  name                = "sg_devops_ddosplan1"
  location            = azurerm_resource_group.sg_devops_vnet_rg.location
  resource_group_name = azurerm_resource_group.sg_devops_vnet_rg.name
}

resource "azurerm_virtual_network" "sg_devops_vnet" {
  name                = "sg_devops_vnet"
  location            = azurerm_resource_group.sg_devops_vnet_rg.location
  resource_group_name = azurerm_resource_group.sg_devops_vnet_rg.name
  address_space       = ["10.80.0.0/16"]
  #dns_servers         = ["10.80.0.4", "10.80.0.5"]


  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.sg_devops_ddosplan1.id
    enable = false
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_associate_1" {
  subnet_id                 = azurerm_subnet.public_subnet1.id
  network_security_group_id = azurerm_network_security_group.sg_devops_sg.id
}

resource "azurerm_subnet" "public_subnet1" {
  name                 = "public_subnet1"
  resource_group_name  = azurerm_resource_group.sg_devops_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.sg_devops_vnet.name
  address_prefixes     = ["10.80.0.0/24"]
}

resource "azurerm_subnet" "public_subnet2" {
  name                 = "public_subnet2"
  resource_group_name  = azurerm_resource_group.sg_devops_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.sg_devops_vnet.name
  address_prefixes     = ["10.80.2.0/24"]
}

resource "azurerm_subnet" "private_subnet1" {
  name                 = "private_subnet1"
  resource_group_name  = azurerm_resource_group.sg_devops_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.sg_devops_vnet.name
  address_prefixes     = ["10.80.1.0/24"]
}

resource "azurerm_subnet" "private_subnet2" {
  name                 = "private_subnet2"
  resource_group_name  = azurerm_resource_group.sg_devops_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.sg_devops_vnet.name
  address_prefixes     = ["10.80.3.0/24"]
}