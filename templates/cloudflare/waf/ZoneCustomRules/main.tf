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
      expression  = <<-EOF
      (http.request.uri.path contains "/wp-admin")
      or ((ip.src eq 157.66.55.118) or (ip.src eq 52.169.15.235) or (ip.src eq 138.199.18.61) or (ip.src eq 146.70.160.236) or (ip.src eq 52.138.140.234) or (ip.src eq 13.79.228.175) or (ip.src eq 52.178.197.66) or (ip.src eq 13.94.100.142))
      or ((cf.threat_score ge 29) or (cf.client.bot) or (cf.waf.credential_check.password_leaked) or (cf.api_gateway.fallthrough_detected) or (cf.verified_bot_category eq "Search Engine Crawler") or (cf.verified_bot_category eq "AI Crawler") or (cf.verified_bot_category eq "Aggregator") or (cf.verified_bot_category eq "Monitoring & Analytics") or (cf.verified_bot_category eq "Archiver")) or (http.user_agent wildcard r"Expanse*") or (http.user_agent wildcard r"*SemrushBot*") or (http.user_agent wildcard r"*Expanse*Palo Alto*")
      or ((ip.src.country eq "FR") or (ip.src.country eq "UA") or (ip.src.country eq "JP") or (ip.src.country eq "DE") or (ip.src.country eq "CN") or (ip.src.country eq "BG") or (ip.src.country eq "AT") or (ip.src.country eq "RU") or (ip.src.country eq "VN") or (ip.src.country eq "SG") or (ip.src.country eq "PA") or (ip.src.country eq "IN") or (ip.src.country eq "HK") or (ip.geoip.country eq "AU") or (ip.geoip.country eq "SG") or(ip.geoip.country eq "IR") or (ip.geoip.country eq "IE") or (ip.geoip.country eq "BY") or (ip.geoip.country eq "BG") or (ip.geoip.country eq "RU") or (ip.geoip.country eq "AT") or (ip.geoip.country eq "CN") or (ip.geoip.country eq "DE") or (ip.geoip.country eq "JP") or (ip.geoip.country eq "ID") or (ip.geoip.country eq "CH") or (ip.geoip.country eq "SE") or (ip.geoip.country eq "NL"))
      EOF
      description = "My Standard Block Rules"
      enabled     = true
    }
  ]
}
