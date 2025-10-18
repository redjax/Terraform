terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    b2 = {
      source  = "Backblaze/b2"
      version = "~> 0.10.0"
    }
  }
}

## Managed by Terragrunt
# module "gh_repo" {
#   source = "../../../../modules/github/Repository/"

#   repository_name        = var.repository_name
#   repository_description = var.repository_description
#   repository_visibility  = var.repository_visibility
#   repository_auto_init   = var.repository_auto_init
#   additional_branches    = var.additional_branches
#   github_owner           = var.github_owner
#   github_token           = var.github_token
# }
