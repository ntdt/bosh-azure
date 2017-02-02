/////////////////////////
//// Storage account ////
/////////////////////////

resource "azurerm_storage_account" "bosh" {
  name                = "nonprodboshstorage"
  depends_on          = ["azurerm_resource_group.bosh"]
  resource_group_name = "${var.env_name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}

resource "azurerm_storage_container" "bosh" {
  name                  = "bosh"
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell" {
  name                  = "stemcell"
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh.name}"
  container_access_type = "blob"
}

resource "azurerm_storage_container" "vhds" {
  name = "vhds"
  resource_group_name   = "${var.env_name}"
  storage_account_name  = "${azurerm_storage_account.bosh.name}"
  container_access_type = "private"
}

resource "azurerm_storage_table" "stemcells" {
  name                 = "stemcells"
  resource_group_name  = "${var.env_name}"
  storage_account_name = "${azurerm_storage_account.bosh.name}"
  
}
