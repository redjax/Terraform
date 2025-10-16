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

## Default branch
variable "default_branch" {
  type        = string
  description = "Name of branch to create in repository."
  default     = "main"
}

## Additional branches to create
variable "additional_branches" {
  type        = list(string)
  description = "Additional branches to create."
  default     = []
}
