// disk snapshot to be recovered from
variable "nexus_disk_source" {
  type = string
  // e.g. "/subscriptions/70123064-74a6-4834-ac94-08c267c6990d/resourceGroups/luw-devtest/providers/Microsoft.Compute/snapshots/exampleDiskSnapshot"
  // if empty (default), new PV will be created
  default = ""
}

variable "nexus_disk_name" {
  type = string
  default = "nexusdisk"
}

variable "nexus_disk_size_gb" {
  type = string
  default = "50"
}

// disk snapshot to be recovered from
variable "jenkins_disk_source" {
  type = string
  // e.g. "/subscriptions/70123064-74a6-4834-ac94-08c267c6990d/resourceGroups/MC_luw-devtest_luw_switzerlandnorth/providers/Microsoft.Compute/snapshots/jenkinsbackup_201214"
  // if empty (default), new PV will be created
  default = ""
}

variable "jenkins_disk_name" {
  type = string
  default = "jenkinsdisk"
}

variable "jenkins_disk_size_gb" {
  type = string
  default = "64"
}

variable "storage_account_type" {
  type = string
  default = "StandardSSD_LRS"
}
//////////////////////////////////////////
variable "tenant_id" {
  type = string
  default = "2f500ad4-c495-4ddc-aa05-d5a275079c79"
}

variable "resource_group_name" {
  type = string
  default = "mc_luw-devtest_luw_switzerlandnorth"
}

variable "location" {
  type = string
  default = "switzerlandnorth"
}
////////////////////////////////////
variable "kubernetes_host" {
  type = string
  default = "kubernetes_host"
}
variable "kubernetes_client_key" {
  type = string
  default = "kubernetes_client_key"
}
variable "kubernetes_client_certificate" {
  type = string
  default = "kubernetes_client_certificate"
}
variable "kubernetes_ca_certificate" {
  type = string
  default = "kubernetes_ca_certificate"
}