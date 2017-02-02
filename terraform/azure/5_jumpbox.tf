resource "azurerm_network_interface" "jumpbox" {
  name                = "jumpbox"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.bosh.name}"

  ip_configuration {
    name                          = "jumpbox_ip_configuration"
    subnet_id                     = "${azurerm_subnet.bosh.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.jumpbox_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.jumpbox.id}" 
  }
}

resource "azurerm_virtual_machine" "jumpbox" {
  name                  = "jumpbox"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.bosh.name}"
  network_interface_ids = ["${azurerm_network_interface.jumpbox.id}"]
  vm_size               = "Standard_A0"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name         = "jb_osdisk1"
    vhd_uri      = "${azurerm_storage_account.bosh.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/jb_osdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  storage_data_disk {
    name          = "jb_datadisk0"
    vhd_uri       = "${azurerm_storage_account.bosh.primary_blob_endpoint}${azurerm_storage_container.bosh.name}/jb_datadisk0.vhd"
    disk_size_gb  = "20"
    create_option = "empty"
    lun           = 0
  }
  os_profile {
    computer_name  = "${var.jumpbox_hostname}"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
