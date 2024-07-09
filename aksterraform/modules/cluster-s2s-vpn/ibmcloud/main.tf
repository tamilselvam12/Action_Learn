terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.21.2"
    }
  }
}

provider "ibm" {
  region = var.region
  iaas_classic_api_key = var.iaas_classic_api_key
  iaas_classic_username = var.iaas_classic_username
}

resource "ibm_compute_ssh_key" "s2s_vpn_vm_key" {
    label = "s2s_vpn_vm_key"
    public_key = var.ssh_public_key
}

resource "ibm_compute_vm_instance" "main" {
  hostname                   = var.vm_name
  domain                     = "dummy.domain"
  os_reference_code          = "UBUNTU_18_64"
  datacenter                 = var.datacenter
  hourly_billing             = true
  private_network_only       = false
  cores                      = 2
  memory                     = 4096
  disks                      = [25]
  #user_metadata              = "{\"value\":\"newvalue\"}"
  public_vlan_id             = var.public_vlan_id
  private_vlan_id            = var.private_vlan_id
  ipv6_enabled               = false
  #transient 				 = false
  #dedicated_acct_host_only   = false
  ssh_key_ids = [ibm_compute_ssh_key.s2s_vpn_vm_key.id]
  
  provisioner "file" {
    connection {
      type     = "ssh"
      host     = ibm_compute_vm_instance.main.ipv4_address
      user     = var.ssh_username
      private_key = file("~/.ssh/id_rsa")
    }
    source      = "${path.module}/../install_ipsec.sh"
    destination = "/tmp/install_ipsec.sh"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = ibm_compute_vm_instance.main.ipv4_address
      user     = var.ssh_username
      private_key = file("~/.ssh/id_rsa")
    }
    inline = [
      "chmod +x /tmp/install_ipsec.sh",
      "sudo /tmp/install_ipsec.sh ${ibm_compute_vm_instance.main.ipv4_address} ${var.local_network} ${var.remote_ipsec_ip} ${var.remote_network} \"${var.ipsec_shared_key}\"",	  
    ]
  }
}