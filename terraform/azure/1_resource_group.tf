///////////////////////////////////////////////
//////// Set Azure Res Group //////////////////
///////////////////////////////////////////////

resource "azurerm_resource_group" "bosh_resource_group" {
  name     = "${var.env_name}"
  location = "${var.location}"
}
