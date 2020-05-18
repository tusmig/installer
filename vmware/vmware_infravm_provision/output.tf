output "dependsOn" { 
	value = "${null_resource.vm-create_done.id}" 
	description="Output Parameter set when the module execution is completed"
}

output "vm_mgmt_network_ip" {
  value = "${vsphere_virtual_machine.vm.0.default_ip_address}"
}            