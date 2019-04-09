variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "vsphere_allow_unverified_ssl" {}
variable "vsphere_dc" {}
variable "vsphere_datastore" {}
variable "vsphere_pool" {}
variable "vsphere_network" {}

variable "compute_instance_count" {}
variable "compute_name_prefix" {}
variable "compute_cpus" {}
variable "compute_mem" {}
variable "compute_guest_id" {}
variable "compute_disk_label" {}
variable "compute_disk_size" {}

module "vsphere" {
  source = "./modules/vsphere"

  vsphere_user = "${var.vsphere_user}"
  vsphere_server = "${var.vsphere_server}"
  vsphere_password = "${var.vsphere_password}"
  vsphere_allow_unverified_ssl = "${var.vsphere_allow_unverified_ssl}"

  vsphere_dc = "${var.vsphere_dc}"
  vsphere_datastore = "${var.vsphere_datastore}"
  vsphere_pool = "${var.vsphere_pool}"
  vsphere_network = "${var.vsphere_network}"

  compute_instance_count = "${var.compute_instance_count}"
  compute_name_prefix = "${var.compute_name_prefix}"
  compute_cpus = "${var.compute_cpus}"
  compute_mem = "${var.compute_mem}"
  compute_guest_id = "${var.compute_guest_id}"
  compute_disk_label = "${var.compute_disk_label}"
  compute_disk_size = "${var.compute_disk_size}"
}
