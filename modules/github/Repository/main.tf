## Repository configuration
resource "github_repository" "main" {
  name        = var.repository_name
  description = var.repository_description
  visibility  = var.repository_visibility
  auto_init   = var.repository_auto_init
}

## Create branch
#  If you do this, the 'terraform destroy' command stops working
# resource "github_branch" "main" {
#   repository = github_repository.main.name
#   branch     = "main"
# }

## Create additional branches
resource "github_branch" "additional" {
  for_each   = toset(var.additional_branches)
  repository = github_repository.main.name
  branch     = each.value
}
