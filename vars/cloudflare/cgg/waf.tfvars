########################
# Cloudflare WAF Rules #
########################

## Unified blocklist
waf_combined_block_ruleset_expression = <<-EOF
(http.user_agent contains "Expanse")
or (http.user_agent contains "SemrushBot")
or (http.user_agent contains "Expanse*Palo*Alto")
or (http.user_agent contains "Palo*Alto*Networks")
or (http.user_agent contains "ALittle")
or (http.user_agent contains "internet-measurement.com")
or (http.user_agent contains "CensysInspect")
or (http.user_agent contains "Censys")
or (http.user_agent contains "censys")
or (http.user_agent contains "AliyunSecBot")
or (http.user_agent contains "facebook")
or (http.user_agent contains "facebookexternalhit")
or (cf.client.bot)
or (cf.verified_bot_category eq "Search Engine Crawler")
or (cf.verified_bot_category eq "AI Crawler")
or (cf.verified_bot_category eq "AI Assistant")
or (cf.verified_bot_category eq "AI Search")
or (cf.verified_bot_category eq "Aggregator")
or (cf.verified_bot_category eq "Monitoring & Analytics")
or (cf.verified_bot_category eq "Archiver")
or (cf.api_gateway.fallthrough_detected)
or (cf.waf.credential_check.password_leaked)
EOF

waf_country_block_ruleset_expression = <<-EOF
(ip.src.country eq "AR")
or (ip.src.country eq "AU")
or (ip.src.country eq "AT")
or (ip.src.country eq "BG")
or (ip.src.country eq "BY")
or (ip.src.country eq "CA")
or (ip.src.country eq "CH")
or (ip.src.country eq "CN")
or (ip.src.country eq "DE")
or (ip.src.country eq "FR")
or (ip.src.country eq "GB")
or (ip.src.country eq "HK")
or (ip.src.country eq "IE")
or (ip.src.country eq "ID")
or (ip.src.country eq "IN")
or (ip.src.country eq "IR")
or (ip.src.country eq "JP")
or (ip.src.country eq "KY")
or (ip.src.country eq "MD")
or (ip.src.country eq "MX")
or (ip.src.country eq "MY")
or (ip.src.country eq "NL")
or (ip.src.country eq "PA")
or (ip.src.country eq "PK")
or (ip.src.country eq "PT")
or (ip.src.country eq "RO")
or (ip.src.country eq "RU")
or (ip.src.country eq "SC")
or (ip.src.country eq "SE")
or (ip.src.country eq "SG")
or (ip.src.country eq "TR")
or (ip.src.country eq "UA")
or (ip.src.country eq "VN")
EOF

## Separate IP blocking because the ruleset gets too large
waf_ip_block_ruleset_expression = <<-EOF
(ip.src eq 157.66.55.118)
EOF

## ALLOW country codes
waf_country_allow_ruleset_expression = <<-EOF
(ip.src.country eq "US")
EOF
