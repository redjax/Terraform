# Cloudflare Zone custom WAF ruleset

This template applies a custom WAF ruleset. Free Cloudflare plans only support 5 rules, so this template is meant to squish all of your rules into a single custom rule to apply to the WAF of your chosen zone(s).

Copy the [`example.terraform.tfvars`](./example.terraform.tfvars) to `terraform.tfvars` and modify the rules to your liking. Run `terraform init -upgrade` and `terraform apply` to apply the template to your firewall.
