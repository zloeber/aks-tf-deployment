# AKS Terraform Deployment

Create an auto-scaling single node pool AKS cluster and immediately deploy something into it. This is example code and modules for use in your own pipelines.

## The Modules

**modules/tf_spn** - A helper module for creating an AzureAD SPN to use for the pipeline service connection and the cluster itself
**modules/tf_roles** - The subscription level roles required to create an AKS cluster within Azure (plus one additional role for allowing for billing looksups which can be very useful for the SPN to be able to do later from within the cluster)
**modules/tf_role_assignments** - Assignment of the roles to a specific resource group to contain the deployment. This does not assign additional keyvault policies or other nice to have permissions though.
**modules/tf_aks_deployment** - The module itself. It is meant to be an example on how you can create your own purpose build cluster deployment in terraform for another team.

## Example

An unvalidated example can be found in the `example` folder. This is an all-in-one approach that somewhat defeats the purpose of the aks module as it assumes you will be using a master terraform CI account to create the spn then use it in the aks module deployment. A better approach is to pre-create the spn, vnet, resource group, roles, and role assignments and pump the SPN credentials into a keyvault that then gets read from for the pipeline contstruction of the cluster in another module/repo.