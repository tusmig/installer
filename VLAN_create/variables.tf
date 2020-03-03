#####################################################################
##
##      Created 2/25/20 by ShowMe team. for VLAN_create
##
#####################################################################

variable "datacenter" {
  type = "string"
  description = "Name of Datacenter for ShowMe"
}

variable "dvs" {
  type = "string"
  description = "Name of distributed virtual switch for ShowMe"
}

variable "vdpg" {
  type = "string"
  description = "Name of Virtual Distributed Port Group for ShowMe"
}

variable "vlanid" {
  type = "string"
  description = "VLAN ID for ShowMe"
}
