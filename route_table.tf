
resource "azurerm_route_table" "devops_rtb_1" {
  name                          = "devops_rtb_1"
  location                      = azurerm_resource_group.sg_devops_vnet_rg.location
  resource_group_name           = azurerm_resource_group.sg_devops_vnet_rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = "10.80.0.0/16"
    next_hop_type  = "vnetlocal"
  }

  route {
    name                   = "route_to_LAB_Vnet"
    address_prefix         = "10.0.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.4"
  }

  route {
    name           = "route_to_Internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet_route_table_association" "devops_rtb_assocation" {
  subnet_id      = azurerm_subnet.public_subnet1.id
  route_table_id = azurerm_route_table.devops_rtb_1.id
}