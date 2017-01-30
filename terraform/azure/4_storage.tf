/////////////////////////
//// Storage account ////
/////////////////////////

resource "azurerm_storage_account" "bosh-azure-storage-account" {
    name = "boshstore"
    resource_group_name = "${var.env_name}"
    location = "${var.location}"
    account_type = "Standard_LRS"
}
