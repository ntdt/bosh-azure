/////////////////////////
//// Storage account ////
/////////////////////////

resource "azurerm_storage_account" "bosh-azure-storage-account" {
  name = "boshstore"
  depends_on          = ["azurerm_resource_group.bosh_resource_group"]
  resource_group_name = "${var.env_name}"
  location = "${var.location}"
  account_type = "Standard_LRS"
}
