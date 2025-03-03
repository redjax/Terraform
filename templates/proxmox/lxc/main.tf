terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json"
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = var.proxmox_tls_insecure

  ## Enable debugging
  #   pm_debug = true
}

resource "proxmox_lxc" "test_container" {
  count       = 1
  target_node = var.proxmox_host
  ostemplate  = var.template_name     # Specify your OS template
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
