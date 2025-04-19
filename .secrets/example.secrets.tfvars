cloudflare_email     = "<email@domain.com>"
cloudflare_api_token = "<your Cloudflare API token"
cloudflare_zone_ids = [
  ## domain1.com
  "00000000000000000000000000000000",
  ## domain2.com
  "00000000000000000000000000000000",
]

## IPs allowed through your firewall, i.e. a home network
# waf_allow_ruleset_expression = <<-EOF
# (ip.src eq 000.00.00.000)
# or (ip.src eq 00.00.000.00)
# or (http.host wildcard "*.example.com")
# or (http.user_agent wildcard r"*AllowString*")
# or (ip.geoip.country eq "US")
# or (ip.src.country eq "US")
# EOF
