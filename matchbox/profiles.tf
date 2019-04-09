// Create a CoreOS-install profile
resource "matchbox_profile" "coreos-install" {
  name   = "coreos-install"
  kernel = "http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz"

  initrd = [
    "http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz",
  ]

  args = [
    "initrd=coreos_production_pxe_image.cpio.gz",
    "coreos.config.url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "coreos.first_boot=yes",
    "console=tty0",
    "console=ttyS0",
  ]

  container_linux_config = "${file("./cl/coreos-install.yaml.tmpl")}"
}

// Create a Ubuntu-install profile
resource "matchbox_profile" "ubuntu-install" {
  name   = "ubuntu-install"
  kernel = "http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux"

  initrd = [
    "http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz",
  ]

  args = [
    "auto=true",
    "priority=critical",
    "preseed/url=https://raw.githubusercontent.com/NVIDIA/deepops/master/containers/pxe/preseed",
  ]

  container_linux_config = "${file("./cl/simple.yaml.tmpl")}"

}

// Create a Ubuntu-cloud profile
resource "matchbox_profile" "ubuntu-cloud" {
  name   = "ubuntu-cloud"
  kernel = "http://cloud-images.ubuntu.com/releases/bionic/release/unpacked/ubuntu-18.04-server-cloudimg-amd64-vmlinuz-generic"

  initrd = [
    "http://cloud-images.ubuntu.com/releases/bionic/release/unpacked/ubuntu-18.04-server-cloudimg-amd64-initrd-generic",
  ]

  args = [
    "root=http://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.vmdk",
  ]

  container_linux_config = "${file("./cl/simple.yaml.tmpl")}"

}

// Create a simple profile which just sets an SSH authorized_key
resource "matchbox_profile" "simple" {
  name                   = "simple"
  container_linux_config = "${file("./cl/simple.yaml.tmpl")}"
}
