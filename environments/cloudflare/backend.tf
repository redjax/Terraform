terraform {
  backend "s3" {
    bucket = "terraform-git-repo"
    key    = "terraform.tfstate"
    region = "us-west-002"
    endpoints = {
      s3 = "https://s3.us-west-002.backblazeb2.com"
    }
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    encrypt                     = true
  }
}
