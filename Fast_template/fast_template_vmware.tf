#####################################################################
##
##      Created 6/20/19 by The ShowMe Team IBM
##
#####################################################################

provider "vsphere" {
# If you have a self-signed cert
  allow_unverified_ssl = true
}

variable "vm_name" {
  type = "string"
  description = "Name of Virtual machine for ShowMe"
}

variable "num_cpus" {
  type = "string"
  description = "Number of CPU's for Virtual machine for ShowMe"
}

variable "memory" {
  type = "string"
  description = "Amount of Memory for Virtual machine in MB for ShowMe"
}

data "vsphere_datacenter" "dc" {
  name = "HDK1"
}

data "vsphere_datastore" "datastore" {
  name          = "NFS_T60701H1_02"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "X7500-ESXi6/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "dvP VM Network 80"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_name}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "/Test/CAMdeployment"


  num_cpus = "${var.num_cpus}"
  memory   = "${var.memory}"
  guest_id = "rhel7_64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 50
  }
  clone {
    template_uuid = "4212f67f-db97-6984-321b-9e1c3d1e52f0"
     customize {
       linux_options {
            host_name = "${var.vm_name}"
            domain = "sol.local"
           } 

    network_interface {}
  }
 }
} 