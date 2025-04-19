terraform {
  required_providers {
    unifi = {
      source  = "virtualguy/unifi"
      version = "0.0.3"
    }
  }
}

provider "unifi" {
  url      = var.unifi_url
  username = var.unifi_username
  password = var.unifi_password
  site     = var.unifi_site
  ## Uncomment if you're using a self-signed certificate
  allow_insecure = true
}

resource "unifi_firewall_group" "country_group" {
  name    = "CountryBlockGroup"
  type    = "country"
  members = var.block_country_codes
}

resource "unifi_firewall_rule" "block_countries" {
  name                       = var.block_country_codes_rule_name
  action                     = "drop"
  enabled                    = true
  rule_type                  = "WAN_IN"
  source_match_type          = "Country"
  source_address_group_names = [unifi_firewall_group.country_group.name]
  destination_network        = "LAN"
}
