resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmss"
  location            = azurerm_resource_group.sg_devops_vnet_rg.location
  resource_group_name = azurerm_resource_group.sg_devops_vnet_rg.name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.probe1.id

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "devopsvm"
    admin_username       = "jaydenaung"
    admin_password       = var.my_password
    custom_data          = file("custom_data.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }


  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration1"
      primary                                = true
      subnet_id                              = azurerm_subnet.public_subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.elb_backend_pool.id]

    }
  }

  tags = {
    environment = "dev"
  }
}