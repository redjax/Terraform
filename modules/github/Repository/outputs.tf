output "remote_url" {
  value       = github_repository.main.http_clone_url
  description = "URL to use when adding remote to local git repo."
}

output "default_branch" {
  value       = github_repository.main.default_branch
  description = "The repository's default branch"
}

output "repository_visibility" {
  value = github_repository.main.visibility
}
