#Variable Processing
# Setup the userdata that will be used for the instance
data "template_file" "userdata_setup" {
  template      = "${file("userdata_setup.template")}"

  vars  = {
    name        = var.username
    token       = var.token
    logic       = "${file("vuln_bootstrap.sh")}"
  }
}

# Create NSG to access web

resource "azurerm_network_security_group" "victim_nsg" {
  depends_on =[azurerm_resource_group.victim_rg]
  
  name                = "Pradel_VM_NSG"
  location            = azurerm_resource_group.victim_rg.location
  resource_group_name = azurerm_resource_group.victim_rg.name
  security_rule {
    name                       = "allow-ssh"
    description                = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  tags = {
    environment = var.environment
  }
}

#Public IP Address

resource "azurerm_public_ip" "vulnerable_pip" {
    name                          = var.vulnerable_vm_pip
    location                      = azurerm_resource_group.victim_rg.location
    resource_group_name           = azurerm_resource_group.victim_rg.name
    allocation_method             = "Static"
}

# Output the public ip of the gateway

output "VulnIP" {
    value     = azurerm_public_ip.vulnerable_pip.ip_address
}


#Create Network Interface
resource "azurerm_network_interface" "vulnerable_nic" {
  name                = var.vulnerable_vm_nic
  location            = azurerm_resource_group.victim_rg.location
  resource_group_name = azurerm_resource_group.victim_rg.name

  ip_configuration {
    name                          = var.vulnerable_vm_name
    subnet_id                     = azurerm_subnet.victim_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.internal_private_ip
    primary                       = "true"
    public_ip_address_id          = azurerm_public_ip.vulnerable_pip.id
  }
}

 #Associate NSG to Network Interface

resource "azurerm_network_interface_security_group_association" "vulnerable_nic_association" {
  network_interface_id      = azurerm_network_interface.vulnerable_nic.id
  network_security_group_id = azurerm_network_security_group.victim_nsg.id
  }


resource "azurerm_virtual_machine" "pradel_vm" {
  name                  = var.vulnerable_vm_name
  location              = azurerm_resource_group.victim_rg.location
  resource_group_name   = azurerm_resource_group.victim_rg.name
  network_interface_ids = [azurerm_network_interface.vulnerable_nic.id]
  depends_on            = [azurerm_network_interface_security_group_association.vulnerable_nic_association]
  
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination     = true
  delete_data_disks_on_termination  = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "Pradel-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vulnerable_vm_name
    admin_username = var.username
    admin_password = var.password
    custom_data    = data.template_file.userdata_setup.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.environment
  }
}

