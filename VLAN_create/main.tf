#####################################################################
##
##      Created 2/25/20 by ShowMe team. for VLAN_create
##
#####################################################################

## REFERENCE {"vsphere_network":{"type": "vsphere_reference_network"}}
# https://www.terraform.io/docs/providers/vsphere/r/distributed_port_group.html

provider "vsphere" {
# If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_distributed_virtual_switch" "dvs" {
  name          = "${var.dvs}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_distributed_port_group" "pg" {
  name                            = "${var.vdpg}"
  distributed_virtual_switch_uuid = "${data.vsphere_distributed_virtual_switch.dvs.id}"
  vlan_id = "${var.vlanid}"
}
