///////////////////////////////////////////////
//////// Set Azure Variables //////////////////
///////////////////////////////////////////////

variable "env_name" {}
variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "location" {}

variable "azure_terraform_vnet_cidr" {}
variable "azure_terraform_subnet_bosh_cidr" {}
variable "jumpbox_private_ip" {}
variable "jumpbox_hostname" {}
variable "vm_admin_username" {}
variable "vm_admin_password" {}
