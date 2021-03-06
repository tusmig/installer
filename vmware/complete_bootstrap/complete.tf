resource "null_resource" "bootstrap_complete_dependsOn" {
  provisioner "local-exec" {
    # Hack to force dependencies to work correctly. Must use the dependsOn var somewhere in the code for dependencies to work. Contain value which comes from previous module.
	  command = "echo The dependsOn output is ${var.dependsOn}"
  }
}

resource "null_resource" "complete_bootstrap" {
  depends_on = ["null_resource.bootstrap_complete_dependsOn"]
  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.vm_os_private_key}"
    host = "${var.vm_ipv4_mgmt_address}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"     
  }
  
  triggers{
  	number_nodes_changed = "${var.number_nodes}"
  	vm_ipv4_worker_addresses_changed = "${var.vm_ipv4_worker_addresses}"
  	#vm_ipv4_controlplane_addresses_changed = "${var.vm_ipv4_controlplane_addresses}" 
  	
  }  

  provisioner "file" {
    source = "${path.module}/scripts/complete_bootstrap.sh"
    destination = "/tmp/complete_bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod +x /tmp/complete_bootstrap.sh",
      "bash -c '/tmp/complete_bootstrap.sh ${var.ocp_cluster_name} ${var.ocp_domain} ${var.vm_ipv4_address} ${var.number_nodes}'"
    ]
  }
}

resource "null_resource" "bootstraped" {
  depends_on = ["null_resource.complete_bootstrap","null_resource.bootstrap_complete_dependsOn"]
  provisioner "local-exec" {
    command = "echo 'Bootstrap monitor created'" 
  }
}