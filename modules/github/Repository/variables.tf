## Repository name
variable "repository_name" {
  type        = string
  description = "Name of repository to create in Github"
  default     = "TFManagedDemo"

  ## Validate name > 0 characters
  validation {
    condition = length(var.repository_name) > 0

    error_message = "Repository name must be at least 1 character in length."
  }

  ## Validate name < 100 characters
  validation {
    condition     = length(var.repository_name) <= 100
    error_message = "Repository name cannot exceed 100 characters."
  }

  ## Validate name uses only valid characters
  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.repository_name))
    error_message = "Only special characters allowed are -, _, and ."
  }

  ## Validate name != *.git
  validation {
    condition     = !can(regex("\\.git$", var.repository_name))
    error_message = "Name cannot end in '.git'"
  }

  ## Validate name is not .
  validation {
    condition     = var.repository_name != "."
    error_message = "The name '.' is reserved by Github."
  }

  ## Validate name is not ..
  validation {
    condition     = var.repository_name != ".."
    error_message = "The name '..' is reserved by Github."
  }
}

## Repository description
variable "repository_description" {
  type        = string
  description = "The description to apply to the repository once it's created."
  default     = "Terraform-managed test repository"
}

## Repository visibility
variable "repository_visibility" {
  type        = string
  description = "The repository's visibility (public/private)"
  default     = "public"

  validation {
    condition     = contains(["private", "public"], var.repository_visibility)
    error_message = "Valid valuess for var: repository_visibility are (public, private)"
  }
}

## Additional branches to create
variable "additional_branches" {
  type        = list(string)
  description = "Additional branches to create."
  default     = []
}

## Name of repository owner
variable "github_owner" {
  type        = string
  description = "Github username who will own the new repository."
  nullable    = false
}

## Github PAT
variable "github_token" {
  type        = string
  description = "Github PAT to use for API calls. Must have permissions equivalent to module actions."
  nullable    = false
  sensitive   = true
}

## Create repo with a default README & initial commit
variable "repository_auto_init" {
  type        = bool
  description = "Initialize new repository. Required for creating branches."
  default     = false
}
