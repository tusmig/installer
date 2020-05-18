output "dependsOn" { 
	value = "${null_resource.vm-create_done.id}" 
	description="Output Parameter set when the module execution is completed"
}

output "vm_mgmt_network_ip" {
  value = "${var.vm_ip4_mgmt_network}"
}            