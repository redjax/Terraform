resource "proxmox_lxc" "test_container" {
  count       = 1
  target_node = var.proxmox_node_name
  ostemplate  = "${var.template_storage}:vztmpl/${var.template_name}"
  password    = var.lxc_root_password # Root password for the LXC container
  cores       = var.cpu_cores
  memory      = var.memory_mb
  swap        = var.swap_mb

  rootfs {
    storage = "local-lvm"
    size    = var.rootfs_size
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.lxc_ip}/24"
    gw     = var.gateway
  }

  hostname = var.container_name
}
