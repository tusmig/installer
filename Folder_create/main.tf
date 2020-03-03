#####################################################################
##
##      Created 3/3/20 by ShowMe team. For Folder_create for Folder_create
##
#####################################################################

resource "vsphere_folder" "folder" {
  path          = "${var.path}"
  type          = "vm"
  datacenter_id = "${var.datacenter_id}"
}