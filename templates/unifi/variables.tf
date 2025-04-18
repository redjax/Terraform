variable "unifi_url" {
  type        = string
  description = "The URL of the Unifi controller"
  sensitive   = true
}

variable "unifi_username" {
  type        = string
  description = "The username of the Unifi user"
  sensitive   = true
}

variable "unifi_password" {
  type        = string
  description = "The password of the Unifi user"
  sensitive   = true
}

variable "unifi_site" {
  type        = string
  description = "The Unifi site to configure"
  default     = "default"
}

variable "block_country_codes" {
  type        = list(string)
  description = "List of country codes to block"
  default     = ["CN", "RU"]
}

variable "block_country_codes_rule_name" {
  type        = string
  description = "Name of the country blocking firewall rule"
  default     = "Block Country Codes"
}
