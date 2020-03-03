#####################################################################
##
##      Created 3/3/20 by ShowMe team. For Folder_create for Folder_create
##
#####################################################################
data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}
resource "vsphere_folder" "folder" {
  path          = "${var.path}"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}