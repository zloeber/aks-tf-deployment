## AKS Terraform Deployment

Create an auto-scaling single node pool AKS cluster and immediately deploy something into it.

This module will use the currently logged in azure account and subscription unless the following variables are exported into your session (or pipeline's session):

```bash
ARM_CLIENT_ID=<app_id>
ARM_CLIENT_SECRET=<app_id_secret>
ARM_SUBSCRIPTION_ID=<subscription_id>
ARM_TENANT_ID=`az account show --output tsv --query tenantId`
```

If you are going to use azure blob for backend state you need this one as well:

```bash
ARM_ACCESS_KEY=<azure storage key>
```

## Requirements

An SPN with appropriate rights to deploy AKS clusters will be required. Additional modules have been provided (in the modules folder) which can be used as a starting point for these efforts. It is assumed that these would be run or used in a higher process via a Terraform CI account with broader permission scoping. The additional modules are:

- tf_spn - Generate a long lived SPN account
- tf_roles - Create subscription level roles with appropriate rights to allow for AKS cluster creation
- tf_role_assignments - Assign roles to an SPN scoped to a resource group that would be used to deploy clusters

## Example

See the example directory for a manifest that will use this repository but may not work without additional work.

This example manifest will create one autoscaled cluster of 1 to 3 nodes in np03 using its own private address range of 10.10.1.0/24 with all data being sourced from keyvault. A few local variables are used to simplify things a bit (and could be used as further abstraction for another module if so desired).

The local `.envrc` file (if using direnv and deploying from a workstation) should look something like this.

```bash
export ARM_CLIENT_ID='<spn_app_id>'
export ARM_CLIENT_SECRET='<spn_secret>'
export ARM_SUBSCRIPTION_ID='<subscription_id>'
export ARM_TENANT_ID=`az account show --output tsv --query tenantId`
```

### Deployment

Assuming you are setup with the correct SPN account exported into your environment variable deployment would be;

```bash
terraform init
terraform plan
terraform apply
```

> **NOTE** This example has no backend state and should be destroyed with `terraform destroy` when done testing or in a pipeline task.