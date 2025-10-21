terraform {
    required_providers {
        proxmox = {
            ssource = "Telmate/proxmox"
            version = "~> 3.0"
        }
    }
}

provider "proxmox" {
    pm_api_url = var.pm_api_url
    pm_api_token_id = var.pm_api_token_id
    pm_api_token_secret = var.proxmox_token
    pm_tls_insecure = var.pm_tls_insecure
}