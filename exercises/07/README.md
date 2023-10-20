# Lab 7: Interacting with Providers

Providers are plugins that Terraform uses to understand various external APIs and cloud providers. Thus far in this workshop, we've used the AWS provider.

* In this exercise, we're going to modify the AWS provider we've been using to create 2 buckets, one per instance of the provider in different regions.

### Add the second provider

1. Add a new provider block to `providers.tf` just under the existing provider block. To make this work you need to set the region at least. You also need to set a `alias` argument to the alternate provider. Something like

 ```hcl
 provider "provider-name" {   // change provider-name to the actual provider name
     features {}
     alias = "alternate"
 }
 ```

2. Add 2 buckets, one per provider. To use the alternate provider you must set the provider argument like this:


 ```hcl
  provider = provider-name.alternate    // change provider-name to the actual provider name
 ```

3. Now, provision all:

 ```bash
 terraform init
 terraform fmt
 terraform validate
 terraform plan -out lab7.tfplan
 terraform apply
 terraform show
 ```

The above should show that you have created a bucket that created with another identity. Validate in AWS console.

### Finishing this exercise

4. Run the following to finish:

 ```bash
 terraform destroy -auto-approve
 ```
