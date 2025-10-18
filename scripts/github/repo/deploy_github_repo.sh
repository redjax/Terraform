#!/usr/bin/env bash

set -uo pipefail

if ! command -v terragrunt &>/dev/null; then
    echo "Terragrunt is not installed." >&2
    echo "  Install Terragrunt & try again: https://terragrunt.gruntwork.io/docs/getting-started/install/" >&2
    exit 1
fi

## Set path vars
ORIGINAL_PATH=$(pwd)
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${THIS_DIR}/../../.." && pwd)"
MODULES_DIR="${REPO_ROOT}/modules"
ENVIRONMENTS_DIR="${REPO_ROOT}/environments"

## Default values
REPO_NAME="TFTestRepo"
REPO_DESCRIPTION="Default description for Terraform-managed repository."
AUTO_INIT=false
ADDITIONAL_BRANCHES=""
GITHUB_OWNER="<UNSET>"
GITHUB_TOKEN=""
VISIBILITY=""
DESTROY=false

## Function to run on any exit code
function cleanup() {
    cd "${ORIGINAL_PATH}"
}
trap cleanup EXIT

## Print CLI usage
function print_help() {
    echo ""
    echo "[ Provision Github Repository ]"
    echo ""
    echo "Usage:"
    echo "  ${0} [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -n, --repo-name             The name of the repository."
    echo "  -d, --repo-description      The description of the repository."
    echo "  -a, --auto-init             Automatically initialize the repository."
    echo "  -b, --additional-branches   Comma-separated list of additional branches."
    echo "  -O, --github-owner          The owner of the repository."
    echo "  -T, --github-token          The access token for the repository."
    echo "  -v, --visibility            The visibility of the repository (public/private)."
    echo "  -D, --destroy               Destroy the repository. Cannot delete existing repositories that were not initialized with this Terraform module."
    echo ""
}

# -----------------------------------------------------------------------------

###################
# Parse arguments #
###################

while [[ $# -gt 0 ]]; do
    case $1 in
      -n|--repo-name)
        if [[ -z $2 ]]; then
            echo "[ERROR] --repo-name provided, but no repo name given."

            print_help
            exit 1
        fi

        REPO_NAME="$2"
        shift 2
        ;;
    -d|--repo-description)
        if [[ -z $2 ]]; then
            echo "[ERROR] --repo-description provided, but no repo description given."

            print_help
            exit 1
        fi

        REPO_DESCRIPTION="$2"
        shift 2
        ;;
    -a|--auto-init)
        AUTO_INIT=true
        shift
        ;;
    -b|--additional-branches)
        if [[ -z $2 ]]; then
            echo "[ERROR] --additional-branches provided, but no additional branches given."

            print_help
            exit 1
        fi

        ADDITIONAL_BRANCHES="$2"
        shift 2
        ;;
    -O|--github-owner)
        if [[ -z $2 ]]; then
            echo "[ERROR] --github-owner provided, but no github owner given."

            print_help
            exit 1
        fi

        GITHUB_OWNER="$2"
        shift 2
        ;;
    -T|--github-token)
        if [[ -z $2 ]]; then
            echo "[ERROR] --github-token provided, but no github token given."

            print_help
            exit 1
        fi

        GITHUB_TOKEN="$2"
        shift 2
        ;;
    -v|--visibility)
        if [[ -z $2 ]]; then
            echo "[ERROR] --visibility provided, but no visibility given."

            print_help
            exit 1
        fi

        VISIBILITY="$2"
        shift 2
        ;;
    -D|--destroy)
        DESTROY=true
        shift
        ;;
    -h|--help)
        print_help
        exit 0
        ;;
    *)
        echo "Unknown argument: $1"

        print_help
        exit 1
        ;;
    esac
done

###################
# Validate inputs #
###################

if [[ "${GITHUB_TOKEN}" == "" ]]; then
    echo "[ERROR] --github-token not provided."
    print_help
    exit 1
fi

if [[ "${GITHUB_OWNER}" == "" ]]; then
    echo "[ERROR] --github-owner not provided."
    print_help
    exit 1
fi

if [[ "${REPO_NAME}" == "" ]]; then
    echo "[ERROR] --repo-name not provided."
    print_help
    exit 1
fi

#############################
# Build Terragrunt commands #
#############################

plan_cmd=(
    terragrunt plan
)

apply_cmd=(
        terragrunt apply -auto-approve
    )

destroy_cmd=(terragrunt destroy)

## Set Terraform env vars
export TF_VAR_repository_name="\"$REPO_NAME\""
export TF_VAR_repository_description="\"$REPO_DESCRIPTION\""
export TF_VAR_repository_auto_init=$AUTO_INIT
export TF_VAR_additional_branches="$ADDITIONAL_BRANCHES"
export TF_VAR_github_owner="$GITHUB_OWNER"
export TF_VAR_github_token="$GITHUB_TOKEN"
export TF_VAR_visibility="$VISIBILITY"

# ------------------------------------------------------------------------------

##################
# Run Terragrunt #
##################

## Change directories to environment directory
cd "${ENVIRONMENTS_DIR}/github/repos/BasicRepository"

if [[ "${DESTROY}" == "true" ]]; then
    echo "Destroying repository: $GITHUB_OWNER/$REPO_NAME"
    echo "  Command: ${destroy_cmd[*]}"
    echo ""

    "${destroy_cmd[@]}"
    if [[ $? -ne 0 ]]; then
        echo "[ERROR] Failed destroying repository: $GITHUB_OWNER/$REPO_NAME"
        exit $?
    fi

    echo ""
    echo "Destroyed repository: $GITHUB_OWNER/$REPO_NAME"

    exit 0
fi

echo ""
echo "Provisioning repository: $GITHUB_OWNER/$REPO_NAME"
echo "  Command: ${plan_cmd[*]}"
echo ""

"${plan_cmd[@]}"
if [[ $? -ne 0 ]]; then
  echo "[ERROR] Failed planning Terragrunt deployment."
  exit $?
fi

echo ""
echo "Please review the plan above."
echo ""

read -n 1 -r -p "Apply the plan? (y/n) " yn

case $yn in
  [Yy]*)
    echo "Applying plan..."
    echo "  Command: ${apply_cmd[*]}"
    echo ""
    ;;
  *)
    echo "Skipping 'terragrunt apply'. To apply manually, run:"
    echo "  cd ${ENVIRONMENTS_DIR}/github/repos/BasicRepository"
    echo "  terragrunt apply"
    echo ""

    exit 0
    ;;
esac

"${apply_cmd[@]}"
if [[ $? -ne 0 ]]; then
  echo "[ERROR] Failed applying Terragrunt deployment."
  exit $?
fi
