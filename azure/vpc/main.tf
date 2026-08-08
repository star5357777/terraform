terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}



module "resource_group" {
	source = "../modules/resource_group"
	rg_name = "module-rg"
	rg_location = "Korea Central"
}

module "virtual_network" {
	source = "../modules/virtual_network"
	vnet_name = "module-vnet"
	rg_name = module.resource_group.rg_name
	rg_location = module.resource_group.rg_location
	vnet_cidr = ["10.10.0.0/16"]
}

module "public_subnet" {
	source = "../modules/subnet"
	rg_name = module.resource_group.rg_name
	vnet_name = module.virtual_network.vnet_name
	subnet_name = ["module-pub-sub-1","module-pub-sub-2"]
	subnet_cidr = ["10.10.1.0/24","10.10.2.0/24"]
}

module "private_subnet" {
	source = "../modules/subnet"
	rg_name = module.resource_group.rg_name
	vnet_name = module.virtual_network.vnet_name
	subnet_name = ["module-pri-sub-1","module-pri-sub-2"]
	subnet_cidr = ["10.10.3.0/24","10.10.4.0/24"]
}

module "public_route_table" {
	source = "../modules/route_table"
	route_table_name = "module-pub-rt"
	rg_location = module.resource_group.rg_location
	rg_name = module.resource_group.rg_name
	route_propagation = "true"
}

module "private_route_table" {
	source = "../modules/route_table"
	route_table_name = "module-pri-rt"
	rg_location = module.resource_group.rg_location
	rg_name = module.resource_group.rg_name
	route_propagation = "false"
}

module "public_route_association" {
	source = "../modules/route_association"
	subnet_id = module.public_subnet.subnet_id
	route_table_id = module.public_route_table.route_table_id
}

module "private_route_association" {
	source = "../modules/route_association"
	subnet_id = module.private_subnet.subnet_id
	route_table_id = module.private_route_table.route_table_id
}

module "public_route" {
	source = "../modules/route"
	rg_name = module.resource_group.rg_name
	route_name = ["local","igw"]
	des_cidr = ["10.10.0.0/16","0.0.0.0/0"]
	next_hop = ["VnetLocal","Internet"]
	route_table_name = module.public_route_table.route_table_name
}

module "private_route" {
	source = "../modules/route"
	rg_name = module.resource_group.rg_name
	route_name = ["local"]
	des_cidr = ["10.10.0.0/16"]
	next_hop = ["VnetLocal"]
	route_table_name = module.private_route_table.route_table_name
}

module "public_ip" {
	source = "../modules/public_ip"
	public_ip_name = ["module-test-vm"]
	rg_name = module.resource_group.rg_name
	rg_location = module.resource_group.rg_location
}

module "network_interface" {
	source = "../modules/network_interface"
	nic_name = ["module-test-vm-nic"]
	rg_location = module.resource_group.rg_location
	rg_name = module.resource_group.rg_name
	nic_ip_name = ["module-test-vm-ip"]
	subnet_id = module.public_subnet.subnet_id
	private_ip_launch = ["Dynamic"]
	public_ip_id = module.public_ip.public_ip_id
}

module "network_security_group" {
	source = "../modules/network_security_group"
	security_group_name = "module-nsg"
	rg_location = module.resource_group.rg_location
	rg_name = module.resource_group.rg_name
}

module "network_security_rule" {
	source = "../modules/network_security_rule"
	security_rule_name = ["AllowSSH","AllowHTTP","AllowHTTPS"]
	priority = [100,300,310]
	direction = ["Inbound","Inbound","Inbound"]
	access = ["Allow","Allow","Allow"]
	protocol = ["Tcp","Tcp","Tcp"]
	source_port = ["*","*","*"]
	des_port = ["22","80","443"]
	source_cidr = [var.admin_ingress_cidr,"*","*"]
	des_cidr = "*"
	rg_name = module.resource_group.rg_name
	nsg_name = module.network_security_group.nsg_name
	
}

module "network_interface_security_group_association" {
	source = "../modules/network_interface_security_group_association"
	count_num = "1"
	nic_id = module.network_interface.nic_id
	nsg_id = module.network_security_group.nsg_id
}

module "virtual_machine" {
	source = "../modules/virtual_machine"
	vm_name = ["module-test-vm"]
	rg_location = module.resource_group.rg_location
	rg_name = module.resource_group.rg_name
	nic_id = module.network_interface.nic_id
	size = ["Standard_D2s_v3"]
	publisher = ["Canonical"]
	offer = ["UbuntuServer"]
	sku = ["16.04-LTS"]
	ver = ["latest"]
	vm_str_name = ["module-test-str"]
	caching = ["ReadWrite"]
	create_option = ["FromImage"]
	managed_disk_type = ["Standard_LRS"]
	vm_computer_name = ["module-test-vm"]
	vm_username = ["rootadmin"]
	vm_password = [var.vm_admin_password]
	disable_password = [false]
}
