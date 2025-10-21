## Source root terragrunt.hcl
include "root" {
  path = find_in_parent_folders("terragrunt.root.hcl")
}

locals {
  base_name = coalesce(
    get_env("VM_NAME", null),
    get_env("REPOSITORY_NAME", null),
    "UnnamedVirtualmachine"
  )

  timestamp = regex_replace(timestamp(), "/|:|T|Z", "-") # removes special chars from timestamp for safe naming

  unique_key = "${local.base_name}-${local.timestamp}"
}

remote_state {
  backend = "s3"

  config = {
    ## Create new state file for each repository deployed by this module.
    #  Use repository name in filename.
    key = "pm.vm.${get_env("VM_NAME", "UnnamedVirtualmachine")}.tfstate"
  }
}

terraform {
  source = "${get_repo_root()}/modules/proxmox/vm"

  extra_arguments "vars" {
    commands = ["init", "plan", "apply", "destroy", "refresh"]

    ## Load .tfvars files, if they exist.
    optional_var_files = [
      "${get_repo_root()}/.secrets/proxmox/secrets.tfvars",
      "${get_repo_root()}/vars/proxmox/VMs/tfdemo.tfvars"
    ]
  }
}

## Default values (will apply if no overrides exist)
#  Overwrite by setting environment variables, i.e.:
#    TF_VAR_name="tf-deb-dns"
inputs = {
    name         = local.base_name
    node         = "proxmox-node1"
    template     = "tf-template-deb12"
    full_clone   = true
    cores        = 2
    memory       = 1024
    disk_size    = "20G"
    disk_type    = "virtio"
    host_storage = "local-lvm"

    networks = [
        {
        bridge = "vmbr0"
        model  = "virtio"
        }
    ]

    ip         = "192.168.1.100/24"
    gateway    = "192.168.1.1"
    dns        = "1.1.1.1 9.9.9.9"
    dns_search = "localdomain"

    bootdisk    = "virtio0"
    enable_agent = true
    autostart   = false
}
