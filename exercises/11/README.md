# Lab 11: Expressions and Meta-Arguments

The idea of "looping" or repeated resource capabilities in Terraform is one of the most common "gotchas".

Declarative infrastructure tools and languages often require or encourage more explicit definition of things
rather than supporting logic where other languages might have an "easier" way of doing things.

Nonetheless, there's still a good deal you can accomplish via Terraform's `count` concept that mimics the idea of loops
and creating multiple copies or versions of a single thing. If you need more complex structures over to loop you can use `for_each` expressions.
If you finally need repeated blocks within a resource you can always use `dynamic` blocks

Modules, as we saw, are another key aspect of reusability in Terraform.

In this exercise you will focus on looping constructs and meta_arguments. Notice you have been given:

- A `providers.tf` file with the normal stuff
- A `variables.tf` and `terraform.tfvars` file to define some variables, later you can play with them to see how the expressions change
- A template `main.tf` file. The idea is to add looping to this file and reuse locals for that

The `main.tf` should deploy:

- A `s3` bucket via a module (we created this before)
- A VPC. The name of the vpc must come from the prefix variable and a random integer
- The amount of subnets set by the variable within the vnet. The name of the subnets must come from the prefix variable and a random integer
- A security group with two ingress rules, one for HTTP and one for HTTPS

Your job is to do this. Take your time and go step by step.

1. First I would recommend adding a local for the cidr range and use a conditional to validate it is of a correct format
2. Then try to use a dynamic block to loop over some map to create the security group rules blocks dynamically
3. Finally create other map and a for_each to create the subnets

Hint: To do that, a good idea is to create a local map of subnet names to address spaces.

Hint 2: To calculate the correct address space for the subnets in the loop you can use the range, and the cidrsubnet functions

Hint 3: To add fields to an existant map you can use the merge function.

This one is hard, so it is OK to take your time.