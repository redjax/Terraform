terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {
  #   api_key = var.cloudflare_api_key
  api_token = var.cloudflare_api_token
  email     = var.cloudflare_email
}

resource "cloudflare_ruleset" "waf_custom_rules" {
  zone_id     = var.cloudflare_zone_id
  name        = "Custom WAF Rules"
  description = "Custom WAF rules for my site"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      expression  = var.waf_ruleset_expression
      description = "My Standard Block Rules"
      enabled     = true
    }
  ]
}
