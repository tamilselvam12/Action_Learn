variable iaas_classic_api_key {
  default = "TO_BE_SET"
}
variable iaas_classic_username {
  default = "TO_BE_SET"
}
variable "region" {
  default = "us-east"
}
variable "resource_group_id" {
  default = "TO_BE_SET"
}
variable "datacenter" {
  default = "tor01"
}
variable "private_vlan_id" {
  default = "3061916"
}
variable "public_vlan_id" {
  default = "3061932"
}
variable "ssh_username" {
  type = string
  default = "root"
}
variable "ssh_public_key" {
  type = string
  default = "ssh-rsa TO_BE_SET"
}
variable "local_network" {
  type = string
  default = "10.114.75.128/26"
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
variable "ipsec_shared_key" {
  type = string
  default = "TO_BE_SET"
}