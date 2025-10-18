## Root terragrunt config. Can be merged with nested terragrunt.hcl files

## Set B2 backend. Use in a nested config like:
# include "root" {
#   path = find_in_parent_folders("root.hcl")
# }
#
# remote_state {
#   config = {
#     key = "gh.repo.BasicRepository.tfstate"
#   }
# }
##
remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-git-repo"
    region = "us-west-2"
    endpoints = {
      s3 = "https://s3.us-west-002.backblazeb2.com"
    }
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
