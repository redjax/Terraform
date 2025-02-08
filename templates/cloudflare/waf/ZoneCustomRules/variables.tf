variable "cloudflare_email" {
  description = "Cloudflare account email"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_key" {
  description = "Cloudflare API key"
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

variable "waf_ruleset_expression" {
  description = "Expression(s) for rules to apply to WAF"
  type        = string
}
