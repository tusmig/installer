variable "vm_os_password"       { type = "string"  description = "Operating System Password for the Operating System User to access virtual machine"}
variable "vm_os_user"           { type = "string"  description = "Operating System user for the Operating System User to access virtual machine"}
variable "vm_ipv4_address_list" { type="list"      description = "IPv4 Address's in List format"}
variable "vm_hostname_list"     { type = "string"}
variable "vm_domain_name"     { type = "string"}
variable "installer_hostname"     { type = "string"}
variable "compute_hostname"     { type = "string"}
variable "private_key"          { type = "string"  description = "Private SSH key Details to the Virtual machine"}
variable "rh_user"              { type = "string" }
variable "rh_password"          { type = "string" }
variable "random"               { type = "string"  description = "Random String Generated"}
variable "dependsOn"            { default = "true" description = "Boolean for dependency"}
variable "vm_ipv4_beheer"       { type= "string"   description = "'beheer' IPv4 Address of virtual machine"}