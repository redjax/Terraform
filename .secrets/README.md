# Secrets

**!! ⚠️ SECRETS WARNING ⚠️ !!**

It is not recommended to store secrets for your modules in a file, even if it is ignored in `.gitignore`. Storing secrets in plain text files is bad security practice.

Instead, you should set environment variables and reference them in your templates. For example, `TF_VAR_db_password`. Terraform will automatically detect environment variables prefixed with `TF_VAR_`.

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
