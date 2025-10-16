## Repository configuration
resource "github_repository" "main" {
  name        = var.repository_name
  description = var.repository_description
  visibility  = var.repository_visibility
  auto_init   = var.repository_auto_init
}

## Create branch
resource "github_branch" "main" {
  repository = github_repository.main.name
  branch     = var.default_branch
}

## Set default branch
resource "github_branch_default" "default" {
  repository = github_repository.main.name
  branch     = var.default_branch
}

## Create additional branches
resource "github_branch" "additional" {
  for_each   = toset(var.additional_branches)
  repository = github_repository.main.name
  branch     = each.value
}
