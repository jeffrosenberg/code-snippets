# Terraform

## Basic CLI commands

> NOTE: Terraform annoyingly uses _single_ dashes for long CLI arguments

```bash
# Don't ask for approval with terraform apply
terraform apply -auto-approve

# Tear down an environment
# NEVER USE ON PRODUCTION ENVIRONMENTS!
terraform destroy
```

## Setting variables

There are several ways to set variables:
in `.tfvar` files, environment variables, or at the command prompt.
All achieve the same objective, and these approaches can also be combined.
See https://developer.hashicorp.com/terraform/language/values/variables.

```bash
# Point to a variable file
terraform apply -var-file=dev.tfvars

# Override a specific variable via CLI arguments
terraform apply -var region=”eu-west-1”

# Use environment variables
# Variables are named TF_VAR_ followed by the name of a declared variable
export TF_VAR_region="eu-west-1"
terraform apply

# Combining multiple sources
# Precedence is left to right (and env vars first)
export TF_VAR_region="eu-west-1"
terraform apply -var-file=dev.tfvars -var-file=region.tfcars -var region="eu-east-2"
```

## Version constraints

See [this docs page](https://developer.hashicorp.com/terraform/language/expressions/version-constraints)

```terraform
# For picky dependencies, pin a version using `=`:
version = "=1.3.12"

# You can combine multiple constraints:
version = ">= 1.2.0, < 2.0.0"

# A common operator , `~>`, allows only the rightmost version component to increment
version = "~> 1.2"
version = "~> 1.2.1"
```

## Modifying state

### Terraform import

```bash
terraform import azurerm_storage_account.api /subscriptions/5fe4fd56-cce6-4ef7-baa1-a82faf7e3f58/resourceGroups/hbarebates-api-dev/providers/Microsoft.Storage/storageAccounts/hbarebatesapidev150311

terraform import azurerm_consumption_budget_resource_group.api_budget /subscriptions/5fe4fd56-cce6-4ef7-baa1-a82faf7e3f58/resourceGroups/API-Dev/providers/Microsoft.Consumption/budgets/hbarebates-api-dev-budget
terraform import azurerm_consumption_budget_resource_group.web_budget /subscriptions/5fe4fd56-cce6-4ef7-baa1-a82faf7e3f58/resourceGroups/Web-Dev/providers/Microsoft.Consumption/budgets/hbarebates-web-dev-budget
terraform import azurerm_consumption_budget_resource_group.db_budget /subscriptions/5fe4fd56-cce6-4ef7-baa1-a82faf7e3f58/resourceGroups/SQL-Dev/providers/Microsoft.Consumption/budgets/hbarebates-db-dev-budget
```

### Force replacement of a resource

You can use `terraform taint` to mark a resource for replacement on the next run:

```bash
terraform taint azurerm_linux_function_app.api
```
This works, but [is deprecated](https://developer.hashicorp.com/terraform/cli/commands/taint).
As the documentation explains:

> We recommend the -replace option because the change will be reflected in the Terraform plan, letting you understand how it will affect your infrastructure before you take any externally-visible action. When you use terraform taint, other users could create a new plan against your tainted object before you can review the effects.

The new version:

```bash
terraform apply -var-file=my.tfvars -replace="azurerm_linux_function_app.api"
```

## Generating initial Terraform

Getting started with an empty Terraform project can be tough;
it's helpful to have a template or scaffold to use.
If this is a type of project you haven't created before,
consider using a generator like [Yeoman](https://yeoman.io):

```bash
yo az-terra-module
```