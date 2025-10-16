#!/usr/bin/env bash

set -uo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${THIS_DIR}/../../.." && pwd)"

show_help() {
    cat <<EOF
Usage: $0 [OPTIONS]

Terraform Github repository automation script.

Options:
  --s3-credentials-file <file>  Path to S3 storage provider credentials (default: .secrets/backblazeB2/b2.secrets.sh)
  --auto-approve                Automatically approve Terraform apply actions
  --tfvars-file <file>          Path to a tfvars file (default: waf.tfvars)
  --secrets-file <file>         Path to a secrets.tfvars file (default: .secrets/cloudflare/waf.secrets.tfvars)
  --plan                        Run 'terraform plan' instead of 'apply'
  --validate                    Run 'terraform validate'
  --upgrade                     Run 'terraform init -upgrade' on the module
  --init                        Run 'terraform init' on the environment
  --migrate                     Use with --init to migrate state
  --destroy                     Destroy Terraform-managed resource
  -h, --help                    Show this help message and exit

Examples:
  $0 --plan --tfvars-file=myvars.tfvars
  $0 --auto-approve --secrets-file=prod.secrets.tfvars

EOF
}

# Default values
S3_CREDENTIALS_FILE="${REPO_ROOT}/.secrets/backblazeB2/b2.secrets.sh"
AUTO_APPROVE=0
TFVARS_FILE="tftestrepo.tfvars"
SECRETS_FILE="secrets.tfvars"
DESTROY=0
PLAN=0
VALIDATE=0
UPGRADE=0
INIT=0
MIGRATE=0

while [[ $# -gt 0 ]]; do
    case $1 in
    --s3-credentials-file)
        if [[ -z $2 ]]; then
            echo "[ERROR] --s3-credential-file provided, but no credential path given."
            show_help
            exit 1
        fi

        S3_CREDENTIALS_FILE="$2"
        shift 2
        ;;
    --auto-approve)
        AUTO_APPROVE=1
        shift
        ;;
    --tf-vars-file)
        if [[ -z $2 ]]; then
            echo "[ERROR] --tf-vars-file provided, but no path to .tfvars filename given"
            show_help
            exit 1
        fi

        TFVARS_FILE="$2"
        shift 2
        ;;
    --secrets-file)
        if [[ -z $2 ]]; then
            echo "[ERROR] --secrets-file provided, but not secrets.tfvars filename given"
            show_help
            exit 1
        fi

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
    --destroy)
        DESTROY=1
        shift
        ;;
    -h | --help)
        show_help
        exit 0
        ;;
    *)
        echo "[ERROR] Invalid option: $1"
        show_help
        exit 1
        ;;
    esac
done

# Ensure Terraform is installed
if ! command -v terraform >/dev/null 2>&1; then
    echo "Terraform is not installed." >&2
    exit 1
fi

# Load S3 credentials if not already set
S3_CREDENTIALS_LOADED=1
if [[ -z "${AWS_ACCESS_KEY_ID:-}" || -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
    S3_CREDENTIALS_LOADED=0
fi

if [[ $S3_CREDENTIALS_LOADED -eq 0 ]]; then
    if [[ ! -f "$S3_CREDENTIALS_FILE" ]]; then
        echo "S3 credentials file not found: $S3_CREDENTIALS_FILE" >&2
        exit 1
    fi
    # shellcheck source=/dev/null
    source "$S3_CREDENTIALS_FILE"
    if [[ -z "${AWS_ACCESS_KEY_ID:-}" || -z "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
        echo "Failed to load AWS credentials from $S3_CREDENTIALS_FILE" >&2
        exit 1
    fi
    echo "S3 credentials loaded successfully."
fi

# Set paths
MODULES_ROOT="${REPO_ROOT}/modules"
ENVIRONMENTS_ROOT="${REPO_ROOT}/environments"
VARS_ROOT="${REPO_ROOT}/vars"
SECRETS_ROOT="${REPO_ROOT}/.secrets"

## -----

MODULE_PATH="$MODULES_ROOT/github/Repository"
ENVIRONMENT_PATH="$ENVIRONMENTS_ROOT/github/repos/TFTestRepo"
VARS_PATH="$VARS_ROOT/github/repos/$TFVARS_FILE"
SECRETS_PATH="$SECRETS_ROOT/github/$SECRETS_FILE"

if [[ ! -d "$MODULE_PATH" ]]; then
    echo "[ERROR] Could not find module path: $MODULE_PATH"
    exit 1
fi

if [[ ! -d "$ENVIRONMENT_PATH" ]]; then
    echo "[ERROR] Could not find environment path: $ENVIRONMENT_PATH"
    exit 1
fi

if [[ ! -f "$VARS_PATH" ]]; then
    echo "[ERROR] Could not find vars file path: $VARS_PATH"
    exit 1
fi

if [[ ! -f "$SECRETS_PATH" ]]; then
    echo "[ERROR] Could not find secrets path: $SECRETS_PATH"
    exit 1
fi

# Core logic
if [[ $INIT -eq 1 ]]; then
    if [[ $MIGRATE -eq 1 ]]; then
        echo "Initializing Github repository module & migrating state"
        terraform -chdir="$ENVIRONMENT_PATH" init -migrate-state
    else
        echo "Initializing Github repository module"
        terraform -chdir="$ENVIRONMENT_PATH" init
    fi
elif [[ $UPGRADE -eq 1 ]]; then
    echo "Upgrading Github repository module"
    terraform -chdir="$MODULE_PATH" init -upgrade
elif [[ $VALIDATE -eq 1 ]]; then
    echo "Validating Github repository"
    terraform -chdir="$ENVIRONMENT_PATH" validate
elif [[ $PLAN -eq 1 ]]; then
    echo "Planning Github repository"
    terraform -chdir="$ENVIRONMENT_PATH" plan -var-file="$VARS_PATH" -var-file="$SECRETS_PATH"
elif [[ $DESTROY -eq 1 ]]; then
    echo "Destroying Github repository"
    CMD=(terraform -chdir="$ENVIRONMENT_PATH" destroy -var-file="$VARS_PATH" -var-file="$SECRETS_PATH")
    if [[ $AUTO_APPROVE -eq 1 ]]; then
        CMD+=("-auto-approve")
    fi
    "${CMD[@]}"
    echo "Destroyed Github repository"
else
    echo "Applying Github repository"
    CMD=(terraform -chdir="$ENVIRONMENT_PATH" apply -var-file="$VARS_PATH" -var-file="$SECRETS_PATH")
    if [[ $AUTO_APPROVE -eq 1 ]]; then
        CMD+=("-auto-approve")
    fi
    "${CMD[@]}"
    echo "Applied Github repository"
fi
