output "dependsOn" { value = "${null_resource.vm-create_done.id}" description="Output Parameter when Module Complete"}

output "vm_ipv4_beheer" {
  value = "${vsphere_virtual_machine.vm.default_ip_address}"
}
