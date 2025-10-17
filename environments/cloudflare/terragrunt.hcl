terraform {
  source = "${get_repo_root()}/modules/cloudflare/WafZoneCustomRules"

  extra_arguments "vars" {
    commands = ["init", "plan", "apply", "destroy", "refresh"]

    required_var_files = [
      "${get_repo_root()}/.secrets/cloudflare/waf.secrets.tfvars",
      "${get_repo_root()}/vars/cloudflare/waf.tfvars"
    ]
  }
}

inputs = {
  cloudflare_api_token                  = ""
  cloudflare_email                      = ""
  cloudflare_zone_ids                   = ""
  waf_allow_ruleset_expression          = ""
  waf_country_allow_ruleset_expression  = ""
  waf_combined_block_ruleset_expression = ""
  waf_ip_block_ruleset_expression       = ""
  waf_country_block_ruleset_expression  = ""
  waf_priority_block_ruleset_expression = ""
}