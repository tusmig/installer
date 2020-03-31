#####################################################################
##
##      Created 3/2/20 by admin. for Create_VM
##
#####################################################################
#variables for DNS entry
variable "dns_userid" {
  type = "string"
}

variable "dns_password" {
  type = "string"
}

variable "dns_server" {
  type = "string"
}

variable "winrm_use_ntlm" {
  type = "string"
}

variable "winrm_insecure" {
  type = "string"
}

variable "winrm_https" {
  type = "string"
}

variable "winrm_port" {
  type = "string"
}

# variables for vsphere
variable "datacenter" {
  type = "string"
  description = "Name of Datacenter for ShowMe"
}

variable "datastore" {
  type = "string"
  description = "Name of datastore for ShowMe"
}

variable "resource_pool" {
  type = "string"
  description = "Name of resource pool for ShowMe"
}

variable "network" {
  type = "string"
  description = "Name of network for ShowMe"
}

variable "domain" {
  type = "string"
  description = "Name of domain for ShowMe"
}

# variables for VM
variable "vm_name" {
  type = "string"
  description = "Name of Virtual machine for ShowMe"
}

variable "vm_num_cpus" {
  type = "string"
  description = "Number of CPU's for Virtual machine for ShowMe"
}

variable "vm_vsphere_folder" {
  type = "string"
  description = "Folder for Virtual machine for ShowMe"
}

variable "vm_memory" {
  type = "string"
  description = "Amount of Memory (MB) for Virtual machine for ShowMe"
}

variable "vm_disk_size" {
  type = "string"
  description = "Disk size (GB) for Virtual machine for ShowMe"
}

variable "vm_disk_label" {
  type = "string"
  description = "Disk label for Virtual machine for ShowMe"
}

variable "guest_id" {
  type = "string"
  description = "Guest OS id for Virtual machine for ShowMe"
}

variable "template_uuid" {
  type = "string"
  description = "Template uuid for Virtual machine for ShowMe"
}

variable "ip_gateway" {
  type = "string"
  description = "ipv4 gateway"
}

variable "ip_netmask" {
  type = "string"
  description = "ipv4 netmask"
}

variable "ip_address" {
  type = "string"
  description = "ipv4 ip address"
}