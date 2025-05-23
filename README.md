# Terraform <!-- omit in toc -->

My Terraform monorepo. Stores re-useable templates, examples, docs, etc.

```plaintext
!!! DISCLAIMER !!!

These are my personal Terraform templates, and may be highly specific to my setup. Review everything before running it, and consider copying snippets, instead of whole templates, for your own infrastructure.
```

## Table of Contents <!-- omit in toc -->

- [Description](#description)
- [Install terraform](#install-terraform)
  - [Windows](#windows)
    - [Terraform](#terraform)
    - [OpenTofu](#opentofu)
- [Usage](#usage)

## Description

The modules in the [modules/ path](./modules/) are the building blocks for [environments](./environments/). Environments compose modules into executable "plans," and can accept `.tfvars` variable files from the [vars/ path](./vars/), and secret values from the [.secrets/ path](./.secrets).

**!! ⚠️ SECRETS WARNING ⚠️ !!**

It is not recommended to store secrets for your modules in a file, even if it is ignored in `.gitignore`. Storing secrets in plain text files is bad security practice. Use environment variables instead.

For example, `TF_VAR_db_password`. Terraform will automatically detect environment variables prefixed with `TF_VAR_`.

Example:

```bash
## Export a database password env var
export TF_VAR_db_password="supersecret"
```

In your Terraform template, reference the environment variable as `var.db_password` (without the `TF_VAR_` prefix):

```tf
variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}

resource "some_resource" "example" {
  password = var.db_password
}
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

The [environments/ path](./environments/) stores executable environments that accept [vars](./vars/) and/or [secrets](./.secrets). When planning or executing an environment, use `terraform -chdir="environments/<path to environment directory>"`. Each environment is a Terraform module of its own, meaning you need to add a `variables.tf` like the one in the module(s) that will be called by the environment.

You should run your `terraform` commands from the repository root. This lets you use relative paths, i.e. `-vars-file=".secrets/cloudflare/secrets.tfvars`. Each time you run a `terraform` command from the repository root, set the `chdir` arg to the path to your environment, i.e. `terraform -chdir="environments/cloudflare" init -upgrade`.

Some modules have an [entrypoint script in the scripts/ directory](./scripts/). For example, the [`apply_cf_waf_rules.ps1` script](./scripts/cloudflare/apply_cf_waf_rules.ps1) calls the [`cloudflare` environment](./environments/cloudflare/), which composes the [Cloudflare WAF zone rules module](./modules/cloudflare/WafZoneCustomRules/), the [Cloudflare secrets file (or environment variable)](./.secrets/cloudflare/example.secrets.tfvars), and the [Cloudflare WAF rules .tfvars file](./vars/cloudflare/wafrules.tfvars), then applies the WAF rules to your Cloudflare zone(s).
