waf_block_ruleset_expression = <<-EOF
(http.user_agent wildcard r"Expanse*")
or (http.user_agent wildcard r"*SemrushBot*")
or (http.user_agent wildcard r"*Expanse*Palo Alto*")
or (http.user_agent wildcard r"*Expanse*")
or (http.user_agent wildcard r"*Palo Alto Networks*")
or (http.user_agent wildcard r"*ALittle*")
or (http.user_agent wildcard r"*internet-measurement.com*")
or (cf.client.bot)
or (cf.waf.credential_check.password_leaked)
or (cf.api_gateway.fallthrough_detected)
or (cf.verified_bot_category eq "Search Engine Crawler")
or (cf.verified_bot_category eq "AI Crawler")
or (cf.verified_bot_category eq "Aggregator")
or (cf.verified_bot_category eq "Monitoring & Analytics")
or (cf.verified_bot_category eq "Archiver")
EOF

waf_country_block_ruleset_expression = <<-EOF
(ip.geoip.country eq "AR")
or (ip.geoip.country eq "AU")
or (ip.geoip.country eq "AT")
or (ip.geoip.country eq "BG")
or (ip.geoip.country eq "BY")
or (ip.geoip.country eq "CA")
or (ip.geoip.country eq "CH")
or (ip.geoip.country eq "CN")
or (ip.geoip.country eq "DE")
or (ip.geoip.country eq "FR")
or (ip.geoip.country eq "IE")
or (ip.geoip.country eq "HK")
or (ip.geoip.country eq "ID")
or (ip.geoip.country eq "IN")
or (ip.geoip.country eq "IR")
or (ip.geoip.country eq "JP")
or (ip.geoip.country eq "KY")
or (ip.geoip.country eq "MX")
or (ip.geoip.country eq "MY")
or (ip.geoip.country eq "NL")
or (ip.geoip.country eq "PA")
or (ip.geoip.country eq "RO")
or (ip.geoip.country eq "RU")
or (ip.geoip.country eq "SC")
or (ip.geoip.country eq "SE")
or (ip.geoip.country eq "SG")
or (ip.geoip.country eq "TR")
or (ip.geoip.country eq "UA")
or (ip.geoip.country eq "UK")
or (ip.geoip.country eq "VN")
or (ip.geoip.country eq "HK")
or (ip.geoip.country eq "CN")
or (ip.geoip.country eq "T1")
or (ip.geoip.country eq "MD")
or (ip.src.country eq "AR")
or (ip.src.country eq "AU")
or (ip.src.country eq "AT")
or (ip.src.country eq "BG")
or (ip.src.country eq "BY")
or (ip.src.country eq "CA")
or (ip.src.country eq "CH")
or (ip.src.country eq "CN")
or (ip.src.country eq "DE")
or (ip.src.country eq "FR")
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
or (ip.src.country eq "RO")
or (ip.src.country eq "RU")
or (ip.src.country eq "SC")
or (ip.src.country eq "SE")
or (ip.src.country eq "SG")
or (ip.src.country eq "TR")
or (ip.src.country eq "UA")
or (ip.src.country eq "UK")
or (ip.src.country eq "VN")
or (ip.src.country eq "T1")
or (ip.src.country eq "PT")
EOF

waf_block_ips_ruleset_expression = <<-EOF
(ip.src eq 157.66.55.118)
or (ip.src eq 5.252.155.208)
or (ip.src eq 52.254.9.238)
or (ip.src eq 3.231.206.170)
or (ip.src eq 205.169.39.5)
or (ip.src eq 185.248.85.12)
or (ip.src eq 52.169.15.235)
or (ip.src eq 138.199.18.61)
or (ip.src eq 146.70.160.236)
or (ip.src eq 52.138.140.234)
or (ip.src eq 13.79.228.175)
or (ip.src eq 52.178.197.66)
or (ip.src eq 13.94.100.142)
or (ip.src eq 194.114.136.69)
or (ip.src eq 165.22.185.146)
or (ip.src eq 167.94.138.191)
or (ip.src eq 206.168.34.200)
or (ip.src eq 91.134.79.240)
or (ip.src eq 176.123.10.110)
or (ip.src eq 34.123.170.104)
or (ip.src eq 205.169.39.246)
or (ip.src eq 154.28.229.248)
or (ip.src eq 154.28.229.29)
or (ip.src eq 174.129.121.72)
or (ip.src eq 124.156.179.141)
or (ip.src eq 185.247.137.111)
or (ip.src eq 35.171.144.152)
or (ip.src eq 80.94.95.157)
or (ip.src eq 73.120.166.15)
or (ip.src eq 76.103.212.158)
or (ip.src eq 107.140.215.68)
or (ip.src eq 79.127.229.168)
or (ip.src eq 89.117.41.54)
or (ip.src eq 89.117.41.52)
or (ip.src eq 144.91.99.199)
or (ip.src eq 102.165.16.207)
or (ip.src eq 140.228.21.193)
or (ip.src eq 2.56.20.62)
or (ip.src eq 119.42.149.242)
or (ip.src eq 98.159.39.138)
or (ip.src eq 185.191.171.6)
or (ip.src eq 185.191.171.4)
or (ip.src eq 54.81.110.234)
or (ip.src eq 162.142.125.217)
or (ip.src eq 35.222.91.153)
or (ip.src eq 196.251.81.191)
or (ip.src eq 67.217.228.218)
or (ip.src eq 78.153.140.218)
or (ip.src eq 34.72.176.129)
or (ip.src eq 23.27.145.238)
or (ip.src eq 40.71.195.157)
or (ip.src eq 205.169.39.103)
or (ip.src eq 54.162.236.136)
or (ip.src eq 149.57.180.183)
or (ip.src eq 3.230.2.90)
or (ip.src eq 54.91.103.20)
or (ip.src eq 149.57.180.172)
or (ip.src eq 18.212.190.19)
or (ip.src eq 44.202.242.212)
or (ip.src eq 149.57.180.41)
or (ip.src eq 138.246.253.24)
or (ip.src eq 182.43.70.143)
or (ip.src eq 54.161.202.166)
or (ip.src.asnum eq 12816)
or (ip.src.asnum eq 58519)
or (ip.src.asnum eq 216071)
or (ip.src.asnum eq 64286)
or (ip.src.asnum eq 48753)
or (ip.src.asnum eq 24768)
or (ip.src.asnum eq 14061)
or (ip.src.asnum eq 396982)
or (ip.src.asnum eq 63949)
or (ip.src.asnum eq 8075)
or (ip.src.asnum eq 18779)
or (ip.src.asnum eq 3356)
or (ip.src.asnum eq 399629)
or (ip.src.asnum eq 202306)
or (ip.src.asnum eq 401115)
or (ip.src.asnum eq 32934)
or (ip.src.asnum eq 10557)
or (ip.src.asnum eq 43357)
or (ip.src.asnum eq 51167)
or (ip.src.asnum eq 60068)
or (ip.src.asnum eq 206092)
or (ip.src.asnum eq 211298)
or (ip.src.asnum eq 14061)
or (ip.src.asnum eq 398324)
or (ip.src.asnum eq 48090)
or (ip.src.asnum eq 396982)
or (ip.src.asnum eq 16509)
or (ip.src.asnum eq 23959)
or (ip.src.asnum eq 14061)
or (ip.src.asnum eq 16276)
or (ip.src.asnum eq 14956)
or (ip.src.asnum eq 31898)
or (ip.src.asnum eq 132203)
or (ip.src.asnum eq 398722)
or (ip.src.asnum eq 200019)
or (ip.src.asnum eq 14987)
or (ip.src.asnum eq 398705)
or (ip.src.asnum eq 14956)
or (ip.src.asnum eq 212238)
or (ip.src.asnum eq 13649)
or (ip.src.asnum eq 14618)
or (ip.src.asnum eq 63949)
or (ip.src.asnum eq 46261)
or (ip.src.asnum eq 3356)
or (ip.src.asnum eq 204428)
or (ip.src.asnum eq 209854)
or (ip.src.asnum eq 7922)
or (ip.src.asnum eq 174)
or (ip.src.asnum eq 45753)
or (ip.src.asnum eq 46957)
or (ip.src.asnum eq 47764)
or (ip.src.asnum eq 137409)
or (ip.src.asnum eq 209366)
or (ip.src.asnum eq 215826)
or (ip.src.asnum eq 8075)
EOF

## Copy the lines below into your 'secrets.tfvars' file
# waf_allow_ruleset_expression = <<-EOF
# (ip.src eq xxx.xxx.xxx.xxx)
# EOF
