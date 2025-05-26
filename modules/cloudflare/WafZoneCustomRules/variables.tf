variable "cloudflare_email" {
  description = "Cloudflare account email"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_ids" {
  description = "List of Cloudflare zone IDs to apply WAF rules to"
  type        = list(string)
}

variable "waf_allow_ruleset_expression" {
  description = "Expression(s) for ALLOW rules to apply to WAF"
  type        = string
}

variable "waf_country_allow_ruleset_expression" {
  description = "Expression(s) for ALLOW countries (whitelist) to apply to WAF"
  type        = string
  default     = "(ip.geoip.country eq \"US\")"
}

variable "waf_combined_block_ruleset_expression" {
  description = "Unified BLOCK expressions to apply to WAF"
  type        = string
}

variable "waf_country_block_ruleset_expression" {
  description = "Country BLOCK expressions to apply to WAF"
  type        = string
}

variable "waf_ip_block_ruleset_expression" {
  description = "IP BLOCK expressions to apply to WAF"
  type        = string
}
