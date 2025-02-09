#!/bin/bash

if ! command -v terraform 2>&1 /dev/null; then
    echo "terraform is not installed"
    exit 1
fi

echo "Applying custom Cloudflare WAF rule to all zones in secrets.tfvars"
terraform apply -var-file="secrets.tfvars"

if [[ ! $? -eq 0 ]]; then
    echo "Failed to apply custom Cloudflare WAF rule to all zones in secrets.tfvars"
    exit 1
else
    echo "Applied custom Cloudflare WAF rule to all zones in secrets.tfvars"
    exit 0
fi
