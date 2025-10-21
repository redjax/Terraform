terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.10.0"
    }
  }
}

## Managed by terragrunt
# module "vm" {
#   source = "../../../modules/proxmox/vm"

#   name         = var.name
#   node         = var.node
#   template     = var.template
#   full_clone   = var.full_clone
#   cores        = var.cores
#   memory       = var.memory
#   disk_size    = var.disk_size
#   disk_type    = var.disk_type
#   host_storage = var.host_storage
#   networks     = var.networks
#   ip           = var.ip
#   gateway      = var.gateway
#   dns          = var.dns
#   dns_search   = var.dns_search
#   bootdisk     = var.bootdisk
#   enable_agent = var.enable_agent
#   autostart    = var.autostart
# }
