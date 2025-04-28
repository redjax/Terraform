# Terraform Proxmox

Templates for terraforming a Proxmox host.

## Requirements

- An API user
  - Create a new Proxmox user account by navigating to `Permissions > Users`
  - Set the `Realm` to `Proxmox VE authentication server`
  - Optionally, create a group in `Permissions > Groups` to add this user to, i.e. `IaC`
- A Proxmox role for granting API permissions
  - Navigate to `Permissions > Roles` and add a new role
  - You can name the role whatever you want, i.e. `iac-automation` or `terraform`
  - Give the role the following privileges:

```plaintext
"Datastore.Allocate",
"Datastore.AllocateSpace",
"Datastore.AllocateTemplate",
"Datastore.Audit",
"Mappping.Audit",
"Mapping.Modify",
"Mapping.Use",
"Permissions.Modify"
"Pool.Allocate",
"Pool.Audit",
"Realm.AllocateUser",
"SDN.Allocate",
"SDN.Audit",
"SDN.Use",
"Sys.Audit",
"Sys.Console",
"VM.Allocate",
"VM.Audit",
"VM.Backup",
"VM.Clone",
"VM.Config.CDROM",
"VM.Config.CPU",
"VM.Config.Cloudinit",
"VM.Config.Disk",
"VM.Config.HWType",
"VM.Config.Memory",
"VM.Config.Network",
"VM.Config.Options",
"VM.Console",
"VM.Migrate",
"VM.Monitor",
"VM.PowerMgmt",
"VM.Snapshot",
"VM.Snapshot.Rollback",
```

- An API token
  - Navigate to `Permissions > API Tokens`
  - Create a new API token
    - Select the API user you created in the `User` dropdown
    - You can set whatever value you want for `Token ID`, i.e. `iac-token` or `terraform`
    - It is recommended to set a token expiration, but you can set the token to never expire local development/testing (not recommended).
  - Save your secret somewhere, you cannot view it again once you finish adding the token!
  - Note: I also had to uncheck the `Privilege Separation` box. This may be insecure, I will research and update this step if this is not an optimal setup.

## Links

- [Terraform Proxmox provider (telmate)](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
  - [Terraform Provider - Proxmox LXC resource](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/lxc)
- [Terraform Proxmox provider (bpg)](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
- [Using Terraform or OpenTofu to create LXC containers on Proxmox](https://j.hommet.net/use-terraform-to-create-pve-lxc/)
- [Clone Proxmox LXC containers with Terraform automation](https://www.virtualizationhowto.com/2025/01/clone-proxmox-lxc-containers-with-terraform-automation/)
- [How to deploy VMs in Proxmox with Terraform](https://austinsnerdythings.com/2021/09/01/how-to-deploy-vms-in-proxmox-with-terraform/)
- [Automating Proxmox LXC containers with Terraform: a step-by-step guide](https://medium.com/@work.giteshpradhan/automating-proxmox-lxc-containers-with-terraform-a-step-by-step-guide-62a5e1c650b3)
