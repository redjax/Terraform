# terraform -chdir="environments/cloudflare" apply -var-file="../../.secrets/cloudflare/secrets.tfvars" -var-file="../../vars/cloudflare.tfvars"
Param(
    [Parameter(Mandatory = $false, HelpMessage = "Answer 'yes' to prompts")]
    [switch]$AutoApprove = $false,
    [Parameter(Mandatory = $false, HelpMessage = "Path to a tfvars file")]
    [string]$TFVarsFile = "terraform.tfvars",
    [Parameter(Mandatory = $false, HelpMessage = "Path to a secrets.tfvars file")]
    [string]$SecretsFile = "secrets.tfvars"
)

$PathSeparator = [IO.Path]::DirectorySeparatorChar

[string]$ModulesRoot = "modules"
[string]$EnvironmentsRoot = "environments"
[string]$VarsRoot = "vars"
[string]$SecretsRoot = ".secrets"

Write-Verbose "Modules dir: $($ModulesRoot), exists: $(Test-Path -Path $ModulesRoot)"
Write-Verbose "Environments dir: $($EnvironmentsRoot), exists: $(Test-Path -Path $EnvironmentsRoot)"
Write-Verbose "Vars dir: $($VarsRoot), exists: $(Test-Path -Path $VarsRoot)"
Write-Verbose "Secrets dir: $($SecretsRoot), exists: $(Test-Path -Path $SecretsRoot)"

[string]$ModulePath = (Resolve-Path "$($ModulesRoot)$($PathSeparator)cloudflare$($PathSeparator)WafZoneCustomRules").Path
[string]$EnvironmentPath = (Resolve-Path "$($EnvironmentsRoot)$($PathSeparator)cloudflare").Path
[string]$VarsPath = (Resolve-Path "$($VarsRoot)$($PathSeparator)cloudflare$($PathSeparator)wafrules.tfvars").Path
[string]$SecretsPath = (Resolve-Path "$($SecretsRoot)$($PathSeparator)cloudflare$($PathSeparator)$($SecretsFile)").Path

Write-Verbose "Module dir: $($ModulePath), exists: $(Test-Path -Path $ModulePath)"
Write-Verbose "Environment dir: $($EnvironmentPath), exists: $(Test-Path -Path $EnvironmentPath)"
Write-Verbose "Vars file: $($VarsPath), exists: $(Test-Path -Path $VarsPath)"
Write-Verbose "Secrets file: $($SecretsPath), exists: $(Test-Path -Path $SecretsPath)"

if ( -Not ( Get-Command "terraform" ) ) {
    Write-Error "Terraform is not installed"
    exit 1
}

Write-Information "Applying custom Cloudflare WAF ruleset"
try {
    if ( -Not $AutoApprove ) {
        terraform -chdir="$($EnvironmentPath)" apply -var-file="$VarsPath" -var-file="$SecretsPath"
        Write-Information "Applied custom Cloudflare WAF ruleset"
        exit 0
    }
    else {
        terraform -chdir="$($EnvironmentPath)" apply -var-file="$VarsPath" -var-file="$SecretsPath" -auto-approve
        Write-Information "Applied custom Cloudflare WAF ruleset"
        exit 0
    }
}
catch {
    Write-Error "Failed to apply custom Cloudflare WAF ruleset"
    exit 1
}
