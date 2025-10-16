provider "b2" {}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}
