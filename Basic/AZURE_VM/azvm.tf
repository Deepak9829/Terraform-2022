provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "myvmg" {
  name     = "mytestg"
  location = "Central India"
}


resource "azurerm_virtual_network" "myvpcnet" {
  name                = "mynetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myvmg.location
  resource_group_name = azurerm_resource_group.myvmg.name

}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.myvmg.name
  virtual_network_name = azurerm_virtual_network.myvpcnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.myvmg.location
  resource_group_name = azurerm_resource_group.myvmg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  name                = "mynic"
  location            = azurerm_resource_group.myvmg.location
  resource_group_name = azurerm_resource_group.myvmg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  
    
  }
}

resource "azurerm_network_security_group" "mysg" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.myvmg.location
  resource_group_name = azurerm_resource_group.myvmg.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myvmg.name
  network_security_group_name = azurerm_network_security_group.mysg.name
}

resource "azurerm_network_security_rule" "example1" {
  name                        = "test1234"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myvmg.name
  network_security_group_name = azurerm_network_security_group.mysg.name
}



resource "azurerm_linux_virtual_machine" "main" {
  name                  = "myvm"
  location              = azurerm_resource_group.myvmg.location
  resource_group_name   = azurerm_resource_group.myvmg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "17ESOcs012@123"
   disable_password_authentication = false
  
  
  

   os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.main.public_ip_address
}
