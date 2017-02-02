////////////////////////
//// Addresses /////////
////////////////////////

resource "azurerm_public_ip" "jumpbox" {
  name                         = "jumpbox_public_ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.bosh.name}"
  public_ip_address_allocation = "static"
}

