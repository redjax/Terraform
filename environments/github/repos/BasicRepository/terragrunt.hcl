## Source root terragrunt.hcl
include "root" {
    path = find_in_parent_folders("terragrunt.root.hcl")
}

remote_state {
  backend = "s3"

  config = {
    ## Create new state file for each repository deployed by this module.
    #  Use repository name in filename.
    key = "gh.repo.${get_env("REPOSITORY_NAME", "BasicRepository")}.tfstate"
  }
}

terraform {
  source = "${get_repo_root()}/modules/github/Repository"

  extra_arguments "vars" {
    commands = ["init", "plan", "apply", "destroy", "refresh"]

    ## Load .tfvars files, if they exist.
    optional_var_files = [
      "${get_repo_root()}/.secrets/github/secrets.tfvars",
      "${get_repo_root()}/vars/github/repos/tftestrepo.tfvars"
    ]
  }
}

## Default values (will apply if no overrides exist)
#  Overwrite by setting environment variables, i.e.:
#    TF_VAR_repository_name="MyNewRepo"
inputs = {
  repository_name        = "ERRUnnamedRepository"
  repository_description = "Uninitialized repository provisioned with Terraform."
  repository_visibility  = "private"
  github_owner           = "your_org_or_user"
  repository_auto_init   = false
}
