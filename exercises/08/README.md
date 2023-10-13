# Lab 8: Modules

Terraform is *ALL* about modules.  Every terraform working directory is really just a module that could be reused by others. This is one of the key capabilities of Terraform.

* We are going to modularize the code we've been working with during this workshop
* Instead of constantly redeclaring everything, we are just going to reference the module that we've created and see if it works
* We are also going to use remote modules

## Creating a Module

1. Create a s3_bucket local module. For that you need:

  - Create a subdirectory. It can be named however you want, but a nice practice is `modules/{module_name}`
  - Put your resources, locals, outputs, and variables respect to *only* the bucket in this directory. This directory could look like:

```
modules
   |
   -----s3_bucket
               |
               ------main.tf
               |
               ------outputs.tf
               |
               ------variables.tf
               |
               ------locals.tf
               |
               ------providers.tf
```
   - Congrats! You have a module. Let's reference it!

2. In the `main.tf` (your root module) now we should reference this local module. Check the slides how to do it!.
One important detail I would like you to do is to add variables and outputs in your module. The variables will need to be sent from the root module to your module.
   Finally, the outputs are the things you get back from the module. An example:
   
```hcl
module "mymodule" {
    source = ""  #something
    input_var1 = value1
    input_var2 = value2
}

## Here now we can access the outputs as module.mymodule.output_var
```

Now you do it! Try to call this s3 module twice with different regions to see how you can control where they are being created by redeclaring the local provider.

3. At this point you have created a root module that calls a child module locally defined.
To finalise I would like you to search for the `ec2-instances` module in AWS. Call it in your configuration to create:
   - A "t2.micro" instance in `us-east-1`
   - All resources be to tagged as well as the s3_bucket module

4. Run the whole flow:

   - `terraform init` -> This should download the modules
   - `terraform fmt - recursive`  -> We now need the recursive to do fmt on all files
   - `terraform validate`
   - `terraform plan -out lab8.tfplan`
   - `terraform apply "lab8.tfplan"`

 * Notice that terraform manages each resource as if there is no module division
 * That is, the resources are bucketed into one big change list, but under the hood Terraform's dependency graph will show some separation
 * It's difficult, for example, to create dependencies between two resources that are in different modules
 * You can, however, use interpolation to create a variable dependency between two modules at the root level, ensuring one is created before the other
 * Specific applications where direct resource dependency is required necessitate grouping those resources
 into a single module or project.

5. Don't forget to destroy!
