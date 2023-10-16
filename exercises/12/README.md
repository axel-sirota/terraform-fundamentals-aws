# Lab 12: Configuration drift and Imports

In this lab we will explore how Terraform handles configuration drift.

## Handling drift by reversing

If some resources change, but not with intentions, we can handle that with Terraform. 
To do that start from the `lab 11` and apply that configuration.

1. Now delete a subnet, add another one and change some address spaces. Make a mess.
2. Run `terraform plan` with the correct variable of count_of_subnets as needed. It should say:

```
Note: Objects have changed outside of Terraform
```

And it will show you how it will put everything back in order. If we *don't* want the changes this is the way to go

3. Simple run `terraform apply`. Check that now the environment is exactly as our configuration

## Handling drift by importing

1. Add a new subnet to the VPC, name it something like "weird_subnet". Suppose the AI team needed that and they used the portal, but they need it.

2. To run import you need 2 things:

- The subnet ID
- A resource created in the configuration

3. Fetch the subnet ID from the console

4. Import the subnet. If everything was OK a plan should output that no change should be made.

5. Suppose you decide to not have it after all, you can run:

```bash
terraform state rm resource.label
```

6. Plan again and notice now it is again a drift

7. Destroy everything.
