<#
    .SYNOPSIS
    S3 secrets for Backblaze B2 backend.

    .DESCRIPTION
    Set your Backblaze (or other S3 compatible storage) credentials in the environment.
    Source this file in another script to load the values.

    Example:
    . "$PSScriptRoot\b2.secrets.ps1"
#>

## Backblaze B2 secrets
$Env:AWS_ACCESS_KEY_ID = "YOUR_B2_APPLICATION_KEY_ID"
$Env:AWS_SECRET_ACCESS_KEY = "YOUR_B2_APPLICATION_KEY"

## Fixes an authentication error with Backblaze B2
$env:AWS_REQUEST_CHECKSUM_CALCULATION = "when_required"
$env:AWS_RESPONSE_CHECKSUM_VALIDATION = "when_required"