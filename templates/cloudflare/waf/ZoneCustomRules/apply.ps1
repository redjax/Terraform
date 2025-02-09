Param(
    [Parameter(Mandatory = $false, HelpMessage = "Path to a secrets.tfvars file")]
    [string]$SecretsFile = "secrets.tfvars"
)

if ( -Not ( Get-Command "terraform" ) ) {
    Write-Error "Terraform is not installed"
    exit 1
}

Write-Information "Applying custom Cloudflare WAF ruleset"
try {
    terraform apply -var-file="$SecretsFile"
    Write-Information "Applied custom Cloudflare WAF ruleset"
    exit 0
}
catch {
    Write-Error "Failed to apply custom Cloudflare WAF ruleset"
    exit 1
}