terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.52.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

resource "azurerm_public_ip" "ip" {
  name                  = "${var.vm_name}-ip"
  location              = var.location
  resource_group_name   = var.resource_group_name
  allocation_method     = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location              = var.location
  resource_group_name   = var.resource_group_name
  enable_ip_forwarding  = true
  
  ip_configuration {
    name                          = "${var.vm_name}-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.vm_name}-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm_name
    admin_username = var.ssh_username
    admin_password = var.ssh_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
 
  provisioner "file" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.ip.ip_address
      user     = var.ssh_username
      password = var.ssh_password
    }
    source      = "${path.module}/../install_ipsec.sh"
    destination = "/tmp/install_ipsec.sh"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.ip.ip_address
      user     = var.ssh_username
      password = var.ssh_password
    }
    inline = [
      "chmod +x /tmp/install_ipsec.sh",
      "sudo /tmp/install_ipsec.sh ${azurerm_public_ip.ip.ip_address} ${var.local_network} ${var.remote_ipsec_ip} ${var.remote_network} ${var.ipsec_shared_key}",
    ]
  }
}