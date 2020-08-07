# victim company name 
variable "victim_company" {
  default     = "Pradel"
  description = "Pradel is the victim company"
}

# victim company VNET 
variable "victim_company_vnet" {
  default     = "Pradel-VNET"
}

# victim company subnet 
variable "victim_company_subnet" {
  default     = "Pradel_Subnet"
}

# victim company RG Name
variable "victim_company_rg_name" {
  default     = "Pradel"
}

# azure region
variable "location" {
  description = "Azure region where the resources will be created"
  default     = "Canada East"
}

# victim vnet cidr
variable "victim_vnet_cidr" {
  default     = "10.22.0.0/16"
  description = "VNET"
}

# victim subnet cidr
variable "victim_subnet_cidr" {
  default     = "10.22.1.0/24"
  description = "Subnet"
}

# Vulnerable VM private ip
variable "internal_private_ip" {
  default     = "10.22.1.10"
  description = "Subnet"
}

# environment
variable "environment" {
  default     = "Staging"
  description = "Staging or Production"
}

# Vulnerable-VM-name
variable "vulnerable_vm_name" {
  default     = "Pradel-Juice"
  description = "Name of Vulnerable VM"
}

# Vulnerable-VM Public IP Name
variable "vulnerable_vm_pip" {
  default     = "Pradel-PIP"
  description = "Name of vulnerable VM Public IP "
}

# Vulnerable-VM NIC Name
variable "vulnerable_vm_nic" {
  default     = "Pradel-VM-NIC"
}

# username
variable "username" {
  default     = "etcheby"
  description = "Username"
}

# password
variable "password" {
  default     = "Cpwins1!"
  description = "Password"
}

# token
variable "token" {
  default     = "87b287fe-a5fa-460d-943f-775125116126-02fdf934-de05-4975-aa59-5bda67f7c446"
  description = "WAAP Token"
}
