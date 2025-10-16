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

module "gh_repo" {
  source = "../../../../modules/github/Repository"

  repository_name        = var.repository_name
  repository_description = var.repository_description
  repository_visibility  = var.repository_visibility
  default_branch         = var.default_branch
  additional_branches    = var.additional_branches
}
