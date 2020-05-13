#####################################################################
##
##      Created 3/02/20 by ShowMe Team. for Create_VM
##
#####################################################################

provider "vsphere" {
# If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "beheer" {
  name          = "${var.beheer_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "null_resource" "unsubscribe_rh" {
  provisioner "remote-exec" {
    when        = "destroy"
    connection  = {
      type      = "ssh"
      host      = "${var.ip_address}"
      user      = "${var.vmrh_os_user}"
      password  = "${var.vmrh_os_password}"
    }

    inline = [
      "subscription-manager unregister",
    ]    
  }
}
  
resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_name}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${var.vm_vsphere_folder}"

  provisioner "remote-exec" {
    connection = {
      type     = "winrm"
      host     = "${var.dns_server}"
      user     = "${var.dns_userid}"
      password = "${var.dns_password}"
      agent    = "false"
      insecure = "${var.winrm_insecure}" 
      https    = "${var.winrm_https}"
      port     = "${var.winrm_port}"
      use_ntlm = "${var.winrm_use_ntlm}"
    }

    inline = [
      "powershell -Command \"&{Add-DnsServerResourceRecordA -Name ${var.vm_name} -ZoneName ${var.domain} -IPv4Address ${var.ip_address} -ComputerName ${var.dns_server}}\"",
    ]
  }
  provisioner "remote-exec" {
    when       = "destroy"
    connection = {
      type     = "winrm"
      host     = "${var.dns_server}"
      user     = "${var.dns_userid}"
      password = "${var.dns_password}"
      agent    = "false"
      insecure = "${var.winrm_insecure}" 
      https    = "${var.winrm_https}"
      port     = "${var.winrm_port}"
      use_ntlm = "${var.winrm_use_ntlm}"
    }

    inline = [
      "powershell -Command \"&{Remove-DNSServerResourceRecord -Name ${var.vm_name} -ZoneName ${var.domain} -RRType A -Confirm:$false -Force -ComputerName ${var.dns_server}}\"",
    ]
  }

  num_cpus = "${var.vm_num_cpus}"
  memory   = "${var.vm_memory}"
  guest_id = "${var.guest_id}"

  network_interface {
    network_id = "${data.vsphere_network.beheer.id}"
  }

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  
  disk {
    label = "${var.vm_disk_label}"
    size  = "${var.vm_disk_size}"
  }
  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
     customize {
       linux_options {
            host_name = "${var.vm_name}"
            domain = "${var.domain}"
       } 
    
      network_interface {}
      
      network_interface {
        ipv4_address = "${var.ip_address}"
        ipv4_netmask = "${var.ip_netmask}"
      }

      dns_server_list = ["${var.dns_server_ip}"]
    }
  }
  provisioner "remote-exec" {
    connection  = {
      type      = "ssh"
      host      = "${vsphere_virtual_machine.vm.default_ip_address}"
      user      = "${var.vmrh_os_user}"
      password  = "${var.vmrh_os_password}"
    }

    inline = [
      "subscription-manager register --org=${var.subscript_org} --activationkey=${var.subscript_actkey}",
    ]    
  }
   
  provisioner "file" {
    connection  = {
      type      = "ssh"
      host      = "${vsphere_virtual_machine.vm.default_ip_address}"
      user      = "${var.vmrh_os_user}"
      password  = "${var.vmrh_os_password}"
    }

    destination = "add_static_routes.sh"
    content = <<EOF
# =================================================================
# Copyright 2020 IBM Corporation
# Created by Mano & Jacqueline
# =================================================================
#!/bin/bash

if (( $# != 2 )); then
echo "usage: arg 1 is vm network"
exit -1
fi

#Add route file for interface ens224 and restart network

network='$1'
vpc=`echo -n $network | tail -c 2`

routefile="/etc/sysconfig/network-scripts/route-ens224"
echo "10.10.70.0/24 via 10.1.$vpc.254" > $routefile
echo "10.1.$vpc.0/24 via 10.1.$vpc.254" >> $routefile
echo "10.2.$vpc.0/24 via 10.1.$vpc.254" >> $routefile
echo "10.3.$vpc.0/24 via 10.1.$vpc.254" >> $routefile
cat $routefile

systemctl restart network

EOF
  }
    provisioner "remote-exec" {
    connection  = {
      type      = "ssh"
      host      = "${vsphere_virtual_machine.vm.default_ip_address}"
      user      = "${var.vmrh_os_user}"
      password  = "${var.vmrh_os_password}"
    }

    inline = [
      "chmod +x add_static_routes.sh",
      "add_static_routes.sh \"${var.network}\"",
    ]    
  }
}


 