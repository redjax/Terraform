Param(
    [Parameter(Mandatory = $false, HelpMessage = "Answer 'yes' to prompts")]
    [switch]$AutoApprove = $false,
    [Parameter(Mandatory = $false, HelpMessage = "Path to a secrets.tfvars file")]
    [string]$SecretsFile = "secrets.tfvars"
)

$PathSeparator = [IO.Path]::DirectorySeparatorChar

[string]$TemplatePath = "templates$($PathSeparator)cloudflare$($PathSeparator)waf$($PathSeparator)ZoneCustomRules"
[string]$SecretsFilePath = (Join-Path -Path $TemplatePath -ChildPath $SecretsFile)

Write-Verbose "TemplatePath: $TemplatePath"
Write-Verbose "SecretsFile: $SecretsFilePath"

if ( -Not ( Get-Command "terraform" ) ) {
    Write-Error "Terraform is not installed"
    exit 1
}

if ( -Not ( Test-Path -Path $SecretsFilePath ) ) {
    Write-Error "Secrets file not found at path: $SecretsFilePath"
    exit 1
}

Write-Information "Applying custom Cloudflare WAF ruleset"
try {
    if ( -Not $AutoApprove ) {
        terraform -chdir="$($TemplatePath)" apply -var-file="$SecretsFile"
        Write-Information "Applied custom Cloudflare WAF ruleset"
        exit 0
    }
    else {
        terraform -chdir="$($TemplatePath)" apply -var-file="$SecretsFile" -auto-approve
        Write-Information "Applied custom Cloudflare WAF ruleset"
        exit 0
    }
}
catch {
    Write-Error "Failed to apply custom Cloudflare WAF ruleset"
    exit 1
}