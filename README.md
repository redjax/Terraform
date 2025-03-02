# Terraform

My Terraform monorepo. Stores re-useable templates, examples, docs, etc.

```plaintext
!!! DISCLAIMER !!!

These are my personal Terraform templates, and may be highly specific to my setup. Review everything before running it, and consider copying snippets, instead of whole templates, for your own infrastructure.
```

## Install terraform

**note**: I will probably eventually try out [OpenTofu](https://opentofu.org), and will either start a new repository or find a way to make Terraform & OpenTofu coexist in this repository.

### Windows

#### Terraform

With winget:

```powershell
winget install Hashicorp.Terraform
```

With scoop:

```powershell
scoop install terraform
```

#### OpenTofu

With winget:

```powershell
winget install OpenTofu.Tofu
```

With scoop:

```powershell
scoop install opentofu
```

## Usage

After installing Terraform, navigate to the [`templates/`](./templates/) path and into a module, like the [Cloudflare WAF rule template](./templates/cloudflare/waf/). Once inside a module, look for a `README.md` and follow the instructions within (usually creating/copying file(s) and setting variables).

- Run `terraform init -upgrade` the first time after cloning this repository, and whenever you make changes to the `main.tf` file of a module.
- Before applying a template, you can run a variation of the following to show the "plan" for the deployment:
  - `terraform plan` (show the plan in the terminal)
  - Pass var file(s) with `-var-file="variable_filename.tfvars` (can pass multiple files, and `terraform.tfvars` will always be read)
  - Pass var override(s) with `-var="variable_name="new value"` (can pass multiple var overrides)
  - Output plan to a file with `-out="filename.out"`
    - You can apply a plan later with `terraform apply "filename.out"`
- Execute a module by `cd`-ing to a path with a `main.bicep` file and running some variation of:
  - `terraform apply` (default with no extra values, reads from a `terraform.tfvars` file, if it exists)
  - `terraform apply -var-file="name-of-varfile.tfvars"` (Use any `terraform.tfvars`, plus a specified `.tfvars` file)
    - You can pass multiple `-var-file="..."` params
  - `terraform apply -var="variable_name='value'"` (override individual variables defined in a `variables.tf` and `*.tfvars` file)