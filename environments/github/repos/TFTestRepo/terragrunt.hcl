terraform {
  source = "${get_repo_root()}/modules/github/Repository"

  extra_arguments "vars" {
    commands = ["init", "plan", "apply", "destroy", "refresh"]

    required_var_files = [
      "${get_repo_root()}/.secrets/github/secrets.tfvars",
      "${get_repo_root()}/vars/github/repos/tftestrepo.tfvars"
    ]
  }
}

## Default inputs. Values in .tfvars file will override
inputs = {
  repository_name        = "TFTestRepo"
  repository_description = "Test repo managed via Terragrunt"
  repository_visibility  = "private"
  github_owner           = "your_org_or_user"
  repository_auto_init   = true
}
