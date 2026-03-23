terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.10.0"
    }
  }
}

module "waf_zone_custom_rules" {
  source = "../../modules/cloudflare/WafZoneCustomRules"

  cloudflare_api_token                  = var.cloudflare_api_token
  cloudflare_email                      = var.cloudflare_email
  cloudflare_zone_ids                   = var.cloudflare_zone_ids
  waf_allow_ruleset_expression          = var.waf_allow_ruleset_expression
  waf_country_allow_ruleset_expression  = var.waf_country_allow_ruleset_expression
  waf_combined_block_ruleset_expression = var.waf_combined_block_ruleset_expression
  waf_ip_block_ruleset_expression       = var.waf_ip_block_ruleset_expression
  waf_country_block_ruleset_expression  = var.waf_country_block_ruleset_expression
  waf_priority_block_ruleset_expression = var.waf_priority_block_ruleset_expression
}
