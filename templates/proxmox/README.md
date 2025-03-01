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
    - It is recommended to set a token expiration and to leave `Privilege Separation` checked, but you can set the token to never expire and uncheck the `Privilege Separation` box for local development/testing (not recommended).
  - Save your secret somewhere, you cannot view it again once you finish adding the token!
