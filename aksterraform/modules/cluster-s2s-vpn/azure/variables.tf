variable "location" {
  type = string
  default = "switzerlandnorth"
}
variable "resource_group_name" {
  type = string
  default = "MC_luw-devtest_luw_switzerlandnorth"
}
variable "ssh_username" {
  type = string
  default = "adminuser"
}
variable "ssh_password" {
  type = string
  default = "Password1234!"
}
variable "local_network" {
  type = string
  default = "10.240.0.0/16"
}
variable "remote_ipsec_ip" {
  type = string
  default = "158.177.178.201"
}
variable "remote_network" {
  type = string
  default = "10.194.22.192/26"
}
variable "vm_name" {
  type = string
  default = "ipsecvm"
}
variable "subnet_id" {
  type = string
  default = "/subscriptions/70123064-74a6-4834-ac94-08c267c6990d/resourceGroups/MC_luw-devtest_luw_switzerlandnorth/providers/Microsoft.Network/virtualNetworks/aks-vnet-27457504/subnets/aks-subnet"
}
variable "vm_size" {
  type = string
  default = "Standard_DS1_v2"
}
variable "ipsec_shared_key" {
  type = string
  default = "TO_BE_SET"
}