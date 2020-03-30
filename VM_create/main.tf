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

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_name}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${var.vm_vsphere_folder}"


  num_cpus = "${var.vm_num_cpus}"
  memory   = "${var.vm_memory}"
  guest_id = "${var.guest_id}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "${var.vm_disk_label}"
    size  = "${var.vm_disk_size}"
  }
  clone {
    template_uuid = "${var.template_uuid}"
     customize {
       linux_options {
            host_name = "${var.vm_name}"
            domain = "${var.domain}"
           } 

      network_interface {
        ipv4_address = "${var.ip_address}"
        ipv4_netmask = "${var.ip_netmask}"
      }

      ipv4_gateway = "${var.ip_gateway}"
    }
  }
 }