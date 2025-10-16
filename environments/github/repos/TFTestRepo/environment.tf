terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

module "gh_repo" {
  source = "../../../../modules/github/Repository"

  repository_name        = var.repository_name
  repository_description = var.repository_description
  repository_visibility  = var.repository_visibility
  default_branch         = var.default_branch
  additional_branches    = var.additional_branches
}
