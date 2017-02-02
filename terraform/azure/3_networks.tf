///////////////////////////////////////////////
//////// Build VNET and Subnets ///////////////
///////////////////////////////////////////////

resource "azurerm_virtual_network" "bosh" {
  name                = "${var.env_name}-virtual-network"
  depends_on          = ["azurerm_resource_group.bosh"]
  resource_group_name = "${var.env_name}"
  address_space       = ["${var.azure_terraform_vnet_cidr}"]
  location            = "${var.location}"
}

resource "azurerm_subnet" "bosh" {
  name                      = "${var.env_name}-bosh-subnet"
  resource_group_name       = "${var.env_name}"
  virtual_network_name      = "${azurerm_virtual_network.bosh.name}"
  address_prefix            = "${var.azure_terraform_subnet_bosh_cidr}"
  network_security_group_id = "${azurerm_network_security_group.bosh.id}"
}

