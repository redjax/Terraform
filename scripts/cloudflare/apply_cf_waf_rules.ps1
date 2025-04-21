# terraform -chdir="environments/cloudflare" apply -var-file="../../.secrets/cloudflare/secrets.tfvars" -var-file="../../vars/cloudflare.tfvars"
Param(
    [Parameter(Mandatory = $false, HelpMessage = "Answer 'yes' to prompts")]
    [switch]$AutoApprove = $false,
    [Parameter(Mandatory = $false, HelpMessage = "Path to a tfvars file")]
    [string]$TFVarsFile = "waf.tfvars",
    [Parameter(Mandatory = $false, HelpMessage = "Path to a secrets.tfvars file")]
    [string]$SecretsFile = "waf.secrets.tfvars",
    [Parameter(Mandatory = $false, HelpMessage = "Plan only")]
    [switch]$Plan,
    [Parameter(Mandatory = $false, HelpMessage = "Validate template")]
    [switch]$Validate,
    [Parameter(Mandatory = $false, HelpMessage = "Upgrade module")]
    [switch]$Upgrade,
    [Parameter(Mandatory = $false, HelpMessage = "Initialize module")]
    [switch]$Init
)

## The Cloudflare module uses Backblaze B2 for .tfstate storage.
#  Ensure AWS credentials are set in the environment
if ( -Not $env:AWS_ACCESS_KEY_ID ) {
    Write-Error "AWS_ACCESS_KEY_ID is not set. This is required for Terraform's .tfstate S3 storage."
    exit 1
}
if ( -Not $env:AWS_SECRET_ACCESS_KEY ) {
    Write-Error "AWS_SECRET_ACCESS_KEY is not set. This is required for Terraform's .tfstate S3 storage."
    exit 1
}

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
[string]$VarsPath = (Resolve-Path "$($VarsRoot)$($PathSeparator)cloudflare$($PathSeparator)$($TFVarsFile)").Path
[string]$SecretsPath = (Resolve-Path "$($SecretsRoot)$($PathSeparator)cloudflare$($PathSeparator)$($SecretsFile)").Path

Write-Verbose "Module dir: $($ModulePath), exists: $(Test-Path -Path $ModulePath)"
Write-Verbose "Environment dir: $($EnvironmentPath), exists: $(Test-Path -Path $EnvironmentPath)"
Write-Verbose "Vars file: $($VarsPath), exists: $(Test-Path -Path $VarsPath)"
Write-Verbose "Secrets file: $($SecretsPath), exists: $(Test-Path -Path $SecretsPath)"

if ( -Not ( Get-Command "terraform" ) ) {
    Write-Error "Terraform is not installed"
    exit 1
}

if ( $Init ) {
    Write-Information "Initializing Cloudflare module"
    terraform -chdir="environments/cloudflare" init
    exit 0
}

if ( $Upgrade ) {
    Write-Information "Upgrading Cloudflare module"
    terraform -chdir="$($ModulePath)" init -upgrade
    exit 0
}

if ( $Validate ) {
    Write-Information "Validating custom Cloudflare WAF ruleset"
    terraform -chdir="$($EnvironmentPath)" validate
    exit 0
}

if ( $Plan ) {
    Write-Information "Planning custom Cloudflare WAF ruleset"
    terraform -chdir="$($EnvironmentPath)" plan -var-file="$VarsPath" -var-file="$SecretsPath"
    exit 0
}
else {

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

}
