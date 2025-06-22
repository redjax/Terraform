#!/usr/bin/env bash

set -euo pipefail

# Default values
S3_CREDENTIALS_FILE=".secrets/backblazeB2/b2.secrets.sh"
TFVARS_FILE="waf.tfvars"
SECRETS_FILE="waf.secrets.tfvars"
AUTO_APPROVE=0
PLAN=0
VALIDATE=0
UPGRADE=0
INIT=0
MIGRATE=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --s3-credentials-file)
            S3_CREDENTIALS_FILE="$2"
            shift 2
            ;;
        --auto-approve)
            AUTO_APPROVE=1
            shift
            ;;
        --tfvars-file)
            TFVARS_FILE="$2"
            shift 2
            ;;
        --secrets-file)
            SECRETS_FILE="$2"
            shift 2
            ;;
        --plan)
            PLAN=1
            shift
            ;;
        --validate)
            VALIDATE=1
            shift
            ;;
        --upgrade)
            UPGRADE=1
            shift
            ;;
        --init)
            INIT=1
            shift
            ;;
        --migrate)
            MIGRATE=1
            shift
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

# Ensure AWS credentials are set in the environment, or try to load from file
S3_CREDENTIALS_LOADED=1

if [[ -z "${AWS_ACCESS_KEY_ID:-}" ]]; then
    echo "Warning: AWS_ACCESS_KEY_ID is not set. This is required for Terraform's .tfstate S3 storage."
    S3_CREDENTIALS_LOADED=0
fi
if [[ -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
    echo "Warning: AWS_SECRET_ACCESS_KEY is not set. This is required for Terraform's .tfstate S3 storage."
    S3_CREDENTIALS_LOADED=0
fi

if [[ $S3_CREDENTIALS_LOADED -eq 0 ]]; then
    echo "S3 credentials not found in environment. Attempting to load from file: $S3_CREDENTIALS_FILE"
    if [[ ! -f "$S3_CREDENTIALS_FILE" ]]; then
        echo "Error: S3 credentials file not found: $S3_CREDENTIALS_FILE"
        exit 1
    fi

    # Source the credentials file (must be a shell-compatible export file)
    # If it's a PowerShell file, you may need to convert it to a shell script first.
    # For now, we assume it's a shell script with export statements.
    source "$S3_CREDENTIALS_FILE"

    if [[ -z "${AWS_ACCESS_KEY_ID:-}" || -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
        echo "Error: Failed to load AWS credentials from file: $S3_CREDENTIALS_FILE"
        exit 1
    fi

    echo "S3 credentials loaded from file: $S3_CREDENTIALS_FILE"
fi

echo "S3 credentials loaded successfully."

# Set root paths
MODULES_ROOT="modules"
ENVIRONMENTS_ROOT="environments"
VARS_ROOT="vars"
SECRETS_ROOT=".secrets"

MODULE_PATH="$MODULES_ROOT/cloudflare/WafZoneCustomRules"
ENVIRONMENT_PATH="$ENVIRONMENTS_ROOT/cloudflare"
VARS_PATH="$VARS_ROOT/cloudflare/$TFVARS_FILE"
SECRETS_PATH="$SECRETS_ROOT/cloudflare/$SECRETS_FILE"

# Check if Terraform is installed
if ! command -v terraform >/dev/null 2>&1; then
    echo "Error: Terraform is not installed"
    exit 1
fi

# Run the appropriate Terraform command
if [[ $INIT -eq 1 ]]; then
    if [[ $MIGRATE -eq 1 ]]; then
        echo "Initializing Cloudflare module & migrating state"
        terraform -chdir="$ENVIRONMENT_PATH" init -migrate-state
    else
        echo "Initializing Cloudflare module"
        terraform -chdir="$ENVIRONMENT_PATH" init
    fi
elif [[ $UPGRADE -eq 1 ]]; then
    echo "Upgrading Cloudflare module"
    terraform -chdir="$MODULE_PATH" init -upgrade
elif [[ $VALIDATE -eq 1 ]]; then
    echo "Validating custom Cloudflare WAF ruleset"
    terraform -chdir="$ENVIRONMENT_PATH" validate
elif [[ $PLAN -eq 1 ]]; then
    echo "Planning custom Cloudflare WAF ruleset"
    terraform -chdir="$ENVIRONMENT_PATH" plan -var-file="../../$VARS_PATH" -var-file="../../$SECRETS_PATH"
else
    echo "Applying custom Cloudflare WAF ruleset"
    APPLY_CMD=(terraform -chdir="$ENVIRONMENT_PATH" apply -var-file="../../$VARS_PATH" -var-file="../../$SECRETS_PATH")
    if [[ $AUTO_APPROVE -eq 1 ]]; then
        APPLY_CMD+=(-auto-approve)
    fi
    "${APPLY_CMD[@]}"
    echo "Applied custom Cloudflare WAF ruleset"
fi
