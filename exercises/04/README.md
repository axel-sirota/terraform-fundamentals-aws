# Lab 4: Plans and Applies

For this exercise, we will:

* Initialize our project directory
* run a plan to understand why planning makes sense (and should always be a part of your terraform flow)
* Actually apply our infrastructure, in this case a single rg
* Destroy what we created

### Create Some Infrastructure

1. Initialize your project

2. Next step is to run a plan, which is a dry run that helps us understand what terraform intends to change when it runs an apply.  

 ```bash
 terraform plan -out lab4.tfplan
 ```

 Your output should look something like this:

 ```
 
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.bucket will be created
  + resource "aws_s3_bucket" "bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = (known after apply)
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Team"    = "IT"
          + "company" = "Globomantics"
        }
      + tags_all                    = {
          + "Team"    = "IT"
          + "company" = "Globomantics"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)
    }

  # aws_s3_object.user_student_alias_object will be created
  + resource "aws_s3_object" "user_student_alias_object" {
      + acl                    = (known after apply)
      + bucket                 = (known after apply)
      + bucket_key_enabled     = (known after apply)
      + checksum_crc32         = (known after apply)
      + checksum_crc32c        = (known after apply)
      + checksum_sha1          = (known after apply)
      + checksum_sha256        = (known after apply)
      + content                = "This bucket is reserved for axel"
      + content_type           = (known after apply)
      + etag                   = (known after apply)
      + force_destroy          = false
      + id                     = (known after apply)
      + key                    = "terraform-lab4"
      + kms_key_id             = (known after apply)
      + server_side_encryption = (known after apply)
      + storage_class          = (known after apply)
      + tags                   = {
          + "Team"    = "IT"
          + "company" = "Globomantics"
        }
      + tags_all               = {
          + "Team"    = "IT"
          + "company" = "Globomantics"
        }
      + version_id             = (known after apply)
    }

  # random_integer.rand will be created
  + resource "random_integer" "rand" {
      + id     = (known after apply)
      + max    = 99999
      + min    = 10000
      + result = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────

Saved the plan to: lab4.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "lab4.tfplan"
 ```

 * From the above output, we can see that terraform will create a bucket, a bucket object, and for that first we need a random resource to add randomness.
 * An important line to note is the one beginning with "Plan: 3 to add, 0 to change, 0 to destroy."
<br/><br/>

3. Let's go ahead and let Terraform create the resource group. 

 ```bash
terraform apply "lab4.tfplan"
 ```

 * Terraform will not execute another plan, since you give it one. If you did not provide a plan, it will execute another plan and then ask you if you would like to apply the changes
 * Your output should look like the following (with different numbers):

 ```
random_integer.rand: Creating...
random_integer.rand: Creation complete after 0s [id=94152]
aws_s3_bucket.bucket: Creating...
aws_s3_bucket.bucket: Still creating... [10s elapsed]
aws_s3_bucket.bucket: Still creating... [20s elapsed]
aws_s3_bucket.bucket: Creation complete after 28s [id=bucket-terraform-lab4-94152]
aws_s3_object.user_student_alias_object: Creating...
aws_s3_object.user_student_alias_object: Creation complete after 1s [id=terraform-lab4]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
 ```

4. Now let's run a plan again...

 ```bash
 terraform plan
 ```

 You should notice a couple differences:

 * Terraform informs you that it is Refreshing the State.
    * after the first apply, any subsequent plans and applies will check the infrastructure it created and updates the terraform state with any new information about the resource
 * Next, you'll notice that Terraform informed you that there are no changes to be made. Why?

### Handling Changes

Now, let's try making a change to the resource group and allow Terraform to correct it. Let's change the content of our object.

5. Find `locals.tf` and add a new tag, whatever you want!

 Now run another apply:

 ```bash
 terraform apply
 ```

 The important output for the plan portion of the apply that you should note, something that looks like:

 ```
random_integer.rand: Refreshing state... [id=94152]
aws_s3_bucket.bucket: Refreshing state... [id=bucket-terraform-lab4-94152]
aws_s3_object.user_student_alias_object: Refreshing state... [id=terraform-lab4]

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_s3_bucket.bucket will be updated in-place
  ~ resource "aws_s3_bucket" "bucket" {
        id                          = "bucket-terraform-lab4-94152"
      ~ tags                        = {
            "Team"    = "IT"
            "company" = "Globomantics"
          + "test"    = "test"
        }
      ~ tags_all                    = {
          + "test"    = "test"
            # (2 unchanged elements hidden)
        }
        # (9 unchanged attributes hidden)

        # (3 unchanged blocks hidden)
    }

  # aws_s3_object.user_student_alias_object will be updated in-place
  ~ resource "aws_s3_object" "user_student_alias_object" {
        id                     = "terraform-lab4"
      ~ tags                   = {
            "Team"    = "IT"
            "company" = "Globomantics"
          + "test"    = "test"
        }
      ~ tags_all               = {
          + "test"    = "test"
            # (2 unchanged elements hidden)
        }
        # (10 unchanged attributes hidden)
    }

Plan: 0 to add, 2 to change, 0 to destroy.
 ```

A terraform plan includes a few symbols to tell you what will happen

* `+` means that terraform plans to add this resource
* `-` means that terraform plans to remove this resource
* `-/+` means that terraform plans to destroy then recreate the resource
* `+/-` is similar to the above, but in certain cases a new resource needs to be created before destroying the previous one, we'll cover how you instruct terraform to do this a bit later
* `~` means that terraform plans to modify this resource in place (doesn't require destroy then re-create)
* `<=` means that terraform will read the resource

So our above plan will modify our bucket and bucket object in place per our requested update to the file.

### Destroy

When infrastructure is retired, Terraform can destroy that infrastructure gracefully, ensuring that all resources
are removed and in the order that their dependencies require.

6. Let's destroy our bucket.

 ```bash
 terraform destroy -auto-approve
 ```
