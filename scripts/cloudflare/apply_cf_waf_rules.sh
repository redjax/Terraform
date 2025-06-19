#!/usr/bin/env bash

set -euo pipefail

show_help() {
  cat <<EOF
Usage: $0 [OPTIONS]

Terraform Cloudflare WAF automation script.

Options:
  --s3-credentials-file <file>  Path to S3 storage provider credentials (default: .secrets/backblazeB2/b2.secrets.sh)
  --auto-approve                Automatically approve Terraform apply actions
  --tfvars-file <file>          Path to a tfvars file (default: waf.tfvars)
  --secrets-file <file>         Path to a secrets.tfvars file (default: waf.secrets.tfvars)
  --plan                        Run 'terraform plan' instead of 'apply'
  --validate                    Run 'terraform validate'
  --upgrade                     Run 'terraform init -upgrade' on the module
  --init                        Run 'terraform init' on the environment
  --migrate                     Use with --init to migrate state
  -h, --help                    Show this help message and exit

Examples:
  $0 --plan --tfvars-file=myvars.tfvars
  $0 --auto-approve --secrets-file=prod.secrets.tfvars

EOF
}

# Default values
S3_CREDENTIALS_FILE=".secrets/backblazeB2/b2.secrets.sh"
AUTO_APPROVE=0
TFVARS_FILE="waf.tfvars"
SECRETS_FILE="waf.secrets.tfvars"
PLAN=0
VALIDATE=0
UPGRADE=0
INIT=0
MIGRATE=0

# Parse arguments
OPTS=$(getopt -o h \
--long s3-credentials-file:,auto-approve,tfvars-file:,secrets-file:,plan,validate,upgrade,init,migrate,help \
-n 'parse-options' -- "$@")
eval set -- "$OPTS"

while true; do
  case "$1" in
    --s3-credentials-file) S3_CREDENTIALS_FILE="$2"; shift 2 ;;
    --auto-approve) AUTO_APPROVE=1; shift ;;
    --tfvars-file) TFVARS_FILE="$2"; shift 2 ;;
    --secrets-file) SECRETS_FILE="$2"; shift 2 ;;
    --plan) PLAN=1; shift ;;
    --validate) VALIDATE=1; shift ;;
    --upgrade) UPGRADE=1; shift ;;
    --init) INIT=1; shift ;;
    --migrate) MIGRATE=1; shift ;;
    -h|--help) show_help; exit 0 ;;
    --) shift; break ;;
    *) break ;;
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
MODULES_ROOT="modules"
ENVIRONMENTS_ROOT="environments"
VARS_ROOT="vars"
SECRETS_ROOT=".secrets"

MODULE_PATH="$MODULES_ROOT/cloudflare/WafZoneCustomRules"
ENVIRONMENT_PATH="$ENVIRONMENTS_ROOT/cloudflare"
VARS_PATH="$VARS_ROOT/cloudflare/$TFVARS_FILE"
SECRETS_PATH="$SECRETS_ROOT/cloudflare/$SECRETS_FILE"

# Core logic
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
  terraform -chdir="$ENVIRONMENT_PATH" plan -var-file="$VARS_PATH" -var-file="$SECRETS_PATH"
else
  echo "Applying custom Cloudflare WAF ruleset"
  CMD=(terraform -chdir="$ENVIRONMENT_PATH" apply -var-file="$VARS_PATH" -var-file="$SECRETS_PATH")
  if [[ $AUTO_APPROVE -eq 1 ]]; then
    CMD+=("-auto-approve")
  fi
  "${CMD[@]}"
  echo "Applied custom Cloudflare WAF ruleset"
fi
