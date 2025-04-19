variable "proxmox_host" {
  description = "IP/FQDN for Proxmox host"
  type        = string
}

variable "proxmox_port" {
  description = "Port for Proxmox host"
  type        = number

  default = 8006
}

variable "proxmox_token_id" {
  description = "Proxmox API token ID"
  type        = string

  default = "username@pam!xxxxxxxxxxxxxx"
}

variable "proxmox_token_secret" {
  description = "Proxmox API token secret"
  type        = string

  sensitive = true
}

variable "proxmox_tls_insecure" {
  description = "Allow insecure connections to Proxmox host"
  type        = bool

  default = true
}

variable "template_name" {
  description = "The name of an existing LXC template on your Proxmox host"
  type        = string
}

variable "lxc_root_password" {
  description = "The password to set for the root user of the LXC container"
  type        = string

  sensitive = true
}

variable "lxc_ip" {
  description = "The IP address to assign to the LXC container"
  type        = string

  default = "192.168.1.254"
}

variable "gateway" {
  description = "The gateway to assign to the LXC container"
  type        = string

  default = "192.168.1.1"
}

variable "container_name" {
  description = "The name to assign to the LXC container"
  type        = string
}

variable "cpu_cores" {
  description = "The number of CPU cores to assign to the LXC container"
  type        = number

  default = 2
}

variable "memory_mb" {
  description = "The amount of memory (in MB) to assign to the LXC container"
  type        = number

  default = 2048
}

variable "swap_mb" {
  description = "The amount of swap (in MB) to assign to the LXC container"
  type        = number

  default = 2048
}

variable "rootfs_size" {
  description = "The size of the rootfs to assign to the LXC container"
  type        = string

  default = "10G"
}
