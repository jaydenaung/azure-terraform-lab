resource "azurerm_public_ip" "elb_pubip1" {
  name                = "elb_pubip1"
  location            = azurerm_resource_group.sg_devops_vnet_rg.location
  resource_group_name = azurerm_resource_group.sg_devops_vnet_rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "devops_elb" {
  name                = "devops_elb"
  location            = azurerm_resource_group.sg_devops_vnet_rg.location
  resource_group_name = azurerm_resource_group.sg_devops_vnet_rg.name

  frontend_ip_configuration {
    name                 = "devops_PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.elb_pubip1.id
  }
}

resource "azurerm_lb_backend_address_pool" "elb_backend_pool" {
  resource_group_name = azurerm_resource_group.sg_devops_vnet_rg.name
  loadbalancer_id     = azurerm_lb.devops_elb.id
  name                = "devops_BackEndAddressPool"
}

resource "azurerm_lb_rule" "lb_http" {
  resource_group_name            = azurerm_resource_group.sg_devops_vnet_rg.name
  loadbalancer_id                = azurerm_lb.devops_elb.id
  name                           = "LBRule_80"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_id        = azurerm_lb_backend_address_pool.elb_backend_pool.id
  frontend_ip_configuration_name = "devops_PublicIPAddress"
  probe_id                       = azurerm_lb_probe.probe1.id
}

resource "azurerm_lb_probe" "probe1" {
  resource_group_name = azurerm_resource_group.sg_devops_vnet_rg.name
  loadbalancer_id     = azurerm_lb.devops_elb.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 80
}