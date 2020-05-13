#####################################################################
##
##      Created 3/2/20 by ShowMe team. for Create_VM
##
#####################################################################

output "mgmt_interface_ip" {
    value = "${vsphere_virtual_machine.vm.network_interface.1.ipv4_address}"
}

output "vm_tier_interface_ip" {
    value = "${var.ip_address}"
}