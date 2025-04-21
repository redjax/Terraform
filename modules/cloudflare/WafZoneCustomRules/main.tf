resource "cloudflare_ruleset" "waf_custom_rules" {
  for_each    = toset(var.cloudflare_zone_ids)
  zone_id     = each.value
  name        = "Standard WAF Rules for ${each.value}"
  description = "Standard WAF rules for ${each.value}"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    ## ALLOW traffic rules
    {
      action      = "skip"
      expression  = var.waf_allow_ruleset_expression
      description = "ALLOW Traffic Rules"
      enabled     = true
      action_parameters = {
        ruleset = "current"
      }
    },
    ## BLOCK traffic rules
    {
      action      = "block"
      expression  = var.waf_combined_block_ruleset_expression
      description = "Unified thread BLOCK rules"
      enabled     = true
    },
    ## BLOCK IP rules
    {
      action      = "block"
      expression  = var.waf_ip_block_ruleset_expression
      description = "BLOCK IP Badness"
      enabled     = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}
