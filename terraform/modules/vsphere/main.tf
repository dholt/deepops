provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # If you have a self-signed cert
  allow_unverified_ssl = "${var.vsphere_allow_unverified_ssl}"
}

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_dc}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#data "vsphere_datastore_cluster" "datastore_cluster" {
  #name          = "${var.vsphere_datastore_cluster}"
  #datacenter_id = "${data.vsphere_datacenter.dc.id}"
#}

#resource "vsphere_folder" "folder" {
  #path          = "${var.compute_instance_folder}"
  #type          = "vm"
  #datacenter_id = "${data.vsphere_datacenter.dc.id}"
#}

resource "vsphere_virtual_machine" "vm" {
  count            = "${var.compute_instance_count}"
  name             = "${var.compute_name_prefix}${format("%02d", count.index+1)}"
  #folder           = "${var.compute_instance_folder}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  #datastore_cluster_id     = "${data.vsphere_datastore_cluster.datastore_cluster.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  wait_for_guest_net_timeout = 0

  num_cpus = "${var.compute_cpus}"
  memory   = "${var.compute_mem}"
  memory_reservation   = "${var.compute_mem}"
  guest_id = "${var.compute_guest_id}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    use_static_mac = "true"
    mac_address = "00:50:56:bb:01:${format("%02d", count.index+1)}"
  }

  disk {
    label = "${var.compute_disk_label}"
    size  = "${var.compute_disk_size}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    #customize {
    #  network_interface {}
    #  linux_options {
    #    host_name = "${var.compute_name_prefix}${count.index+1}"
    #    domain = "local"
    #  }
    #}
  }
}

#output "instance_ip_addrs" {
  #value = ["${vsphere_virtual_machine.vm.*.default_ip_address}"]
#}
