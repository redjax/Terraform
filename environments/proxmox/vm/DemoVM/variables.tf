variable "pm_api_url" {
  description = "Proxmox API URL."
  type        = string
  sensitive   = false
}

variable "pm_api_token_id" {
  description = "Proxmox API token ID."
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API token secret."
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Disable TLS verification for Proxmox API."
  type        = bool
  default     = false
}

# Pass all VM module input variables as well, e.g., name, node, template, core count...
variable "name" {
  description = "The name of the virtual machine."
  type        = string
}

# (Include all other input variables matching your module.)
