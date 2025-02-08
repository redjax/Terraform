# Cloudflare Zone custom WAF ruleset

This template applies a custom WAF ruleset. Free Cloudflare plans only support 5 rules, so this template is meant to squish all of your rules into a single custom rule to apply to the WAF of your chosen zone(s).

Copy the [`example.terraform.tfvars`](./example.terraform.tfvars) to `terraform.tfvars` and modify the rules to your liking. Run `terraform init -upgrade` and `terraform apply` to apply the template to your firewall.

## Troubleshooting

If you get a message like this:

```shell
POST "https://api.cloudflare.com/client/v4/zones/<zone-id>/rulesets": 400 Bad Request {
  "result": null,
  "success": false,
  "errors": [
    {
      "code": 20217,
      "message": "'zone' is not a valid value for kind because exceeded maximum number of zone rulesets for phase http_request_firewall_custom",
      "source": {
        "pointer": "/kind"
      }
    }
  ],
  "messages": null
}
```

it means your target zone already has a custom firewall rule. You may not see it in the webUI, but you can find the problem rule ID and delete it. To get the rule's ID, make a request like this:

```shell
curl -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/rulesets"\
    -H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
    -H "Content-Type: application/json"
```

Look for this string in the response: `"phase": "hhttp_request_firewall_custom"` and note the `"id"` value. Then, make an HTTP `DELETE` request to delete the custom rule:

```shell
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/rulesets/$CLOUDFLARE_RULE_ID" \
    -H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
    -H "Content-Type: application/json"
```

Then try to run `terraform apply` again.
