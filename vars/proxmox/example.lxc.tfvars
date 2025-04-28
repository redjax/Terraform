## HDD/SSD name as it appears on Proxmox host (lsblk) or in webUI
template_storage = "<Name of HDD/SSD mount in Proxmox>"
## Container template name, found in $template_storage/template/cache on Proxmox host
#  Example: debian-12-standard_12.7-1_amd64.tar.zst
#  You must create this base template manually, this module copies an existing LXC container
template_name = "<Name of existing template>"
## Name for the new LXC container
container_name = "<New container name>"
## Resource limits
cpu_cores = 2
memory_mb = 2048
swap_mb   = 2048
## Disk size
rootfs_size = "32GB"
## Allow self signed certificate
proxmox_tls_insecure = true
