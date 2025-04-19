module "waf_zone_custom_rules" {
  source = "../../modules/cloudflare/WafZoneCustomRules"

  cloudflare_api_token                 = var.cloudflare_api_token
  cloudflare_email                     = var.cloudflare_email
  cloudflare_zone_ids                  = var.cloudflare_zone_ids
  waf_block_ruleset_expression         = var.waf_block_ruleset_expression
  waf_block_ips_ruleset_expression     = var.waf_block_ips_ruleset_expression
  waf_allow_ruleset_expression         = var.waf_allow_ruleset_expression
  waf_country_block_ruleset_expression = var.waf_country_block_ruleset_expression
  waf_country_allow_ruleset_expression = var.waf_country_allow_ruleset_expression
}
