cloudflare_email     = ""
cloudflare_api_key   = ""
cloudflare_api_token = ""
cloudflare_zone_id   = ""

## Cloudflare rulesets to apply
#  These are examples, although some are valid rules.
#  Modify the examples below based on your needs, or create
#  a custom rule in Cloudflare and copy the expression at the
#  bottom of the rule creation page.
waf_ruleset_expression = <<EOT
(http.request.uri.path contains "/wp-admin)
or (ip.src eq 000.000.000.000)
or (cf.threat_score ge 29)
or (cf.client.bot)
or (cf.waf.credential_check.password_leaked)
or (cf.api_gateway.fallthrough_detected)
or (cf.verified_bot_category eq "Search Engine Crawler")
or (http.user_agent wildcard r"*SemrushBot*")
or (ip.src.country eq "RU")
EOT
