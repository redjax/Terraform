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
  for_each    = toset(var.cloudflare_zone_ids)
  zone_id     = each.value
  name        = "Standard WAF Rules for ${each.value}"
  description = "Standard WAF rulees for ${each.value}"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action      = "allow"
      expression  = var.waf_allow_ruleset_expression
      description = "My Standard Allow Rules"
      enabled     = true
      action_parameters = {
        ruleset = "current"
      }
    },
    {
      action      = "block"
      expression  = var.waf_block_ruleset_expression
      description = "My Standard Block Rules"
      enabled     = true
    },
    {
      action      = "block"
      expression  = var.waf_block_ips_ruleset_expression
      description = "BLOCK IP Badness"
      enabled     = true
    },
    {
      action      = "block"
      expression  = var.waf_country_block_ruleset_expression
      description = "Country blocking Rules"
      enabled     = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}
