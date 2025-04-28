terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc8"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.10.0"
    }
  }
}

module "proxmox_lxc" {
  source = "../../../modules/proxmox/lxc"

  proxmox_node_name    = var.proxmox_node_name
  proxmox_host         = var.proxmox_host
  proxmox_port         = var.proxmox_port
  proxmox_token_id     = var.proxmox_token_id
  proxmox_token_secret = var.proxmox_token_secret
  proxmox_tls_insecure = var.proxmox_tls_insecure

  template_storage = var.template_storage
  template_name    = var.template_name
  container_name   = var.container_name
  cpu_cores        = var.cpu_cores
  memory_mb        = var.memory_mb
  swap_mb          = var.swap_mb
  rootfs_size      = var.rootfs_size

  lxc_ip  = var.lxc_ip
  gateway = var.gateway

  lxc_root_password = var.lxc_root_password
}
