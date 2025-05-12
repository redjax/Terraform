terraform {
  ## Backblaze B2
  backend "s3" {
    bucket = "terraform-git-repo"
    key    = "terraform.tfstate"
    region = "us-west-2"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true

    endpoints = {
      s3 = "https://s3.us-west-002.backblazeb2.com"
    }
  }

  ## Wasabi
  # backend "s3" {
  #   bucket                      = "terraform-git-repo"
  #   key                         = "cloudflare/terraform.tfstate"
  #   region                      = "us-east-1"
  #   skip_credentials_validation = true
  #   skip_requesting_account_id  = true

  #   # skip_region_validation      = true
  #   # skip_metadata_api_check     = true
  #   # skip_requesting_account_id  = true
  #   # skip_s3_checksum            = true
  #   # use_lockfile                = false

  #   endpoints = {
  #     s3 = "https://s3.us-east-1.wasabisys.com"
  #   }
  # }
}
