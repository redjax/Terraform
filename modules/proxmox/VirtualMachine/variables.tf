variable "name" {
  description = "The name of the virtual machine."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "VM name must not be empty."
  }
}

variable "node" {
  description = "The target Proxmox node on which to create the VM."
  type        = string
  validation {
    condition     = length(var.node) > 0
    error_message = "Proxmox node must be specified."
  }
}

variable "template" {
  description = "Name of the Proxmox template to clone from."
  type        = string
  validation {
    condition     = length(var.template) > 0
    error_message = "Template name must be specified."
  }
}

variable "full_clone" {
  description = "Whether to perform a full clone (true) or linked clone (false)."
  type        = bool
  default     = true
}

variable "cores" {
  description = "Number of CPU cores to assign to the VM."
  type        = number
  default     = 2
  validation {
    condition     = var.cores > 0
    error_message = "Cores must be a positive integer."
  }
}

variable "memory" {
  description = "Memory (in MB) allocated to the VM."
  type        = number
  default     = 512

  validation {
    condition     = var.memory >= 512
    error_message = "Memory should be at least 512 MB."
  }
}

variable "disk_size" {
  description = "The disk size for the VM (e.g., '8G', '20G')."
  type        = string
  validation {
    condition     = can(regex("^\\d+[GMK]$", var.disk_size))
    error_message = "Disk size must be a string like '8G', '20G', or '1024M'."
  }
}

variable "disk_type" {
  description = "The disk type/bus, e.g., 'virtio', 'scsi', 'sata', 'ide'."
  type        = string
  default     = "virtio"
  validation {
    condition     = contains(["virtio", "scsi", "sata", "ide"], var.disk_type)
    error_message = "disk_type must be one of 'virtio', 'scsi', 'sata', 'ide'."
  }
}

variable "host_storage" {
  description = "The Proxmox storage location to use for the VM disk."
  type        = string
  validation {
    condition     = length(var.host_storage) > 0
    error_message = "Storage location must be specified."
  }
}

variable "networks" {
  description = "List of network interface configurations for the VM."
  type = list(object({
    bridge = string
    model  = optional(string, "virtio")
    tag    = optional(number)
  }))
  default = [
    { bridge = "vmbr0" }
  ]
}

variable "ip" {
  description = "Static IP address in CIDR format assigned to the VM (e.g., 192.168.1.50/24)."
  type        = string
  default     = "192.168.1.254/24"
  validation {
    condition     = can(regex("^\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\/\\d{1,2}\\b$", var.ip))
    error_message = "IP must be in CIDR format (e.g., 192.168.1.50/24)."
  }
}

variable "gateway" {
  description = "Gateway address for the VM network."
  type        = string
  default     = "192.168.1.1"
  validation {
    condition     = can(regex("^\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b$", var.gateway))
    error_message = "Gateway must be a valid IPv4 address."
  }
}

variable "dns" {
  description = "DNS nameservers for the VM. Space-separated list of IPs."
  type        = string
  default     = "1.1.1.1 9.9.9.9"
}

variable "dns_search" {
  description = "DNS search domain for the VM."
  type        = string
  default     = "localdomain"
}

variable "bootdisk" {
  description = "The disk device to boot from."
  type        = string
  default     = "virtio0"
  validation {
    condition     = can(regex("^(scsi|ide|virtio|sata)[0-9]+$", var.bootdisk))
    error_message = "bootdisk must be in format like 'scsi0', 'ide0', 'virtio0', or 'sata0'."
  }
}

variable "enable_agent" {
  description = "Whether to enable QEMU guest agent."
  type        = bool
  default     = true
}

variable "autostart" {
  description = "Whether the VM starts automatically on host boot."
  type        = bool
  default     = false
}
