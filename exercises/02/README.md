# Lab 2: Using Variables

## Goals

* understand the *four* different ways to declare variables in terraform

### Let's look at our `variables.tf` file...

```hcl
# Declare a variable so we can use it.
variable "student_alias" {
  description = "Your student alias"
}
```

* (BTW, what's the name of our variable?)

### What are the possible properties of a variable?

1. `default`: allows for setting a default value, otherwise terraform requires it to be set in one of four ways
2. `description`: a useful descriptor for the variable
3. `type`: we'll discuss types in depth later but default is `string`

### What is the value of this variable?

* there is no "value" parameter in the syntax for the variable object
* variables stanzas are not meant to be inputs, but rather placeholders for input that can be references in our Terraform code
* variable stanzas can be used this way by simply setting the `default` to the desired value
* but this negates the benefits of Terraform's native re-usability, instead try...


### Let's get started

```bash
terraform init
```

The init should have picked up on the fact that we had a reference to Azure resources in our HCL. Namely, that we defined the azurerm provider in the `providers.tf` file

```hcl
terraform {
  required_version = "~>1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.20"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

## What are the 4 ways we can set our variables?

### 1) The `.tfvars` file

In each terraform working directory, there can be a file named `terraform.tfvars` (or `*.auto.tfvars`) containing HCL that defines values for variables for that working directory.

Let's try a few things:

1. Create a file called `terraform.tfvars` in this directory
2. insert the following code into it:
```hcl
# swap "[your username]" with your provided alias
student_alias = "[your username]"
```
3. then run this in the same directory
```bash
terraform plan -out lab2.tfplan
```

 * You should see that the terraform plan output includes a resource group, and that the value for `name`
 utilizes your chosen identifying text
<br/><br/>

4. Remove your `terraform.tfvars` file so we can look at other ways of passing in the variable:

 ```
 rm terraform.tfvars
 ```

### 2) Command Line Arguments

Another method you can use is to insert variables via the CLI.  This allows for quick variable substitution and
testing because values entered via CLI override values from other methods.

1. Run the following in this working directory (if you were able to complete the previous), swapping for your
identifier like before.

 ```bash
 terraform plan -var 'student_alias=[your username]' -out lab2.tfplan
 ```

 (you can try using a different identifier to see if it worked–as before, you should be able to see the
new identifier in the plan output)

### 3) Using Environment variables

Environment variables can be used to set the value of an input variable=. The name of the variable must be `TF_VAR_` followed by the variable name, and the value is the value of the variable.

1. Try the following:

Unix

 ```bash
 TF_VAR_student_alias=[your username] terraform plan -out lab2.tfplan
 ```

Windows

```
$Env:TF_VAR_student_alias = "[your username]"
terraform plan -out lab2.tfplan
```

2. Remove the env variable

 (this can be a useful method for secrets handling, or other automated use cases)

### 4) Prompt for a variable value

Try just running the plan without having a pre-populated value set:

```bash
terraform plan -out lab2.tfplan
```
