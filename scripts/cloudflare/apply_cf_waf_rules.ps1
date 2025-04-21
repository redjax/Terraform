# terraform -chdir="environments/cloudflare" apply -var-file="../../.secrets/cloudflare/secrets.tfvars" -var-file="../../vars/cloudflare.tfvars"
Param(
    [Parameter(Mandatory = $false, HelpMessage = "Path to S3 storage provider credentials.")]
    [string]$S3CredentialsFile = ".secrets/cloudflare/b2.secrets.ps1",
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
#  Try loading from .secrets/cloudflare/b2.secrets.ps1
if ( -Not $env:AWS_ACCESS_KEY_ID ) {
    Write-Warning "AWS_ACCESS_KEY_ID is not set. This is required for Terraform's .tfstate S3 storage."
    $S3CredentialsLoaded = $false
}
if ( -Not $env:AWS_SECRET_ACCESS_KEY ) {
    Write-Warning "AWS_SECRET_ACCESS_KEY is not set. This is required for Terraform's .tfstate S3 storage."
    $S3CredentialsLoaded = $false
}

## If S3 credentials were not already set, try loading from a file
if ( -Not $S3CredentialsLoaded ) {
    Write-Debug "S3 credentials were not detected in the environment. Attempting to load from file: $S3CredentialsFile"
    if ( -Not (Test-Path -Path $S3CredentialsFile) ) {
        Write-Error "S3 credentials file not found: $S3CredentialsFile"
        exit(1)
    }

    try {
        . $S3CredentialsFile
    }
    catch {
        Write-Error "Failed to load S3 credentials from file: $S3CredentialsFile"
        exit(1)
    }

    ## Re-check that the credentials were loaded
    if ( -Not $env:AWS_ACCESS_KEY_ID ) {
        Write-Warning "AWS_ACCESS_KEY_ID is not set. This is required for Terraform's .tfstate S3 storage."
        $S3CredentialsLoaded = $false
    }
    if ( -Not $env:AWS_SECRET_ACCESS_KEY ) {
        Write-Warning "AWS_SECRET_ACCESS_KEY is not set. This is required for Terraform's .tfstate S3 storage."
        $S3CredentialsLoaded = $false
    }

    ## Indicate that S3 credentials were loaded into env vars successfully
    $S3CredentialsLoaded = $true
}

if ( -Not $S3CredentialsLoaded ) {
    Write-Error "AWS credentials were not detected in the environment and could not be loaded from file: $S3CredentialsFile"
    exit(1)
}
else {
    Write-Output "S3 credentials loaded successfully."

    Write-Verbose "Key ID: $($env:AWS_ACCESS_KEY_ID)"
    Write-Verbose "Key Secret: $($env:AWS_SECRET_ACCESS_KEY)"
}

## Detect path separator (/ or \)
$PathSeparator = [IO.Path]::DirectorySeparatorChar

## Set root paths for modules, environments, vars, and secrets
[string]$ModulesRoot = "modules"
[string]$EnvironmentsRoot = "environments"
[string]$VarsRoot = "vars"
[string]$SecretsRoot = ".secrets"

Write-Verbose "Modules dir: $($ModulesRoot), exists: $(Test-Path -Path $ModulesRoot)"
Write-Verbose "Environments dir: $($EnvironmentsRoot), exists: $(Test-Path -Path $EnvironmentsRoot)"
Write-Verbose "Vars dir: $($VarsRoot), exists: $(Test-Path -Path $VarsRoot)"
Write-Verbose "Secrets dir: $($SecretsRoot), exists: $(Test-Path -Path $SecretsRoot)"

## Set paths to Cloudflare module, environment, vars, and secrets
[string]$ModulePath = (Resolve-Path "$($ModulesRoot)$($PathSeparator)cloudflare$($PathSeparator)WafZoneCustomRules").Path
[string]$EnvironmentPath = (Resolve-Path "$($EnvironmentsRoot)$($PathSeparator)cloudflare").Path
[string]$VarsPath = (Resolve-Path "$($VarsRoot)$($PathSeparator)cloudflare$($PathSeparator)$($TFVarsFile)").Path
[string]$SecretsPath = (Resolve-Path "$($SecretsRoot)$($PathSeparator)cloudflare$($PathSeparator)$($SecretsFile)").Path

Write-Verbose "Module dir: $($ModulePath), exists: $(Test-Path -Path $ModulePath)"
Write-Verbose "Environment dir: $($EnvironmentPath), exists: $(Test-Path -Path $EnvironmentPath)"
Write-Verbose "Vars file: $($VarsPath), exists: $(Test-Path -Path $VarsPath)"
Write-Verbose "Secrets file: $($SecretsPath), exists: $(Test-Path -Path $SecretsPath)"

## Test terraform is installed
if ( -Not ( Get-Command "terraform" ) ) {
    Write-Error "Terraform is not installed"
    exit 1
}

## Validate input parameters
switch ($true) {
    { $Init } {
        Write-Information "Initializing Cloudflare module"
        terraform -chdir="environments/cloudflare" init
    }
    { $Upgrade } {
        Write-Information "Upgrading Cloudflare module"
        terraform -chdir="$($ModulePath)" init -upgrade
    }
    { $Validate } {
        Write-Information "Validating custom Cloudflare WAF ruleset"
        terraform -chdir="$($EnvironmentPath)" validate
    }
    { $Plan } {
        Write-Information "Planning custom Cloudflare WAF ruleset"
        terraform -chdir="$($EnvironmentPath)" plan -var-file="$VarsPath" -var-file="$SecretsPath"
    }
    default {
        Write-Information "Applying custom Cloudflare WAF ruleset"
        $applyCommand = "terraform -chdir=`"$($EnvironmentPath)`" apply -var-file=`"$VarsPath`" -var-file=`"$SecretsPath`""
        if ($AutoApprove) {
            $applyCommand += " -auto-approve"
        }

        try {
            Invoke-Expression $applyCommand
            Write-Information "Applied custom Cloudflare WAF ruleset"
        }
        catch {
            Write-Error "Failed to apply custom Cloudflare WAF ruleset"
            exit 1
        }
    }
}
