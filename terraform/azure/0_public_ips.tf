////////////////////////
//// Addresses /////////
////////////////////////

resource "azurerm_public_ip" "bosh-public-ip" {
  name                         = "bosh-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.bosh_resource_group.name}"
  public_ip_address_allocation = "static"
}

