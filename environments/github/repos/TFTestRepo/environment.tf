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
}
