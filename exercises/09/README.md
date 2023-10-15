# Lab 9: Error Handling and Troubleshooting

* Let's look at what the different types of errors we discussed look like
* In each part of this exercise you'll get a feel for some common error scenarios and how to identify them

### Process Errors

Process errors are really about just something problematic in way that `terraform` is run.

1. What happens when you run `apply` before `init`? Try it.

 You should see something like:

 ```

╷
│ Error: Inconsistent dependency lock file
│
│ The following dependency selections recorded in the lock file are inconsistent with the current configuration:
│   - provider registry.terraform.io/hashicorp/aws: required by this configuration but no version is selected
│   - provider registry.terraform.io/hashicorp/random: required by this configuration but no version is selected
│
│ To make the initial dependency selections that will initialize the dependency lock file, run:
│   terraform init
╵
 ```

As we know, one of `init`'s jobs is to ensure that dependencies such as providers, modules, etc. are pulled
in and available locally within your project. If we don't run `init` first, none of our other terraform operations have all the requirements they need to do their job.

How about another process error example?

2. the `apply` command has an argument that tells it
not to prompt you for input variables: `-input=[true|false]`. Let's try running `apply` with that argument set to false:

 ```bash
 terraform init
 terraform apply -input=false
 ```

 ...which should give you output like:

 ```
╷
│ Error: No value for required variable
│
│   on variables.tf line 4:
│    4: variable "region" {
│
│ The root module input variable "region" is not set, and has no default value. Use a -var or -var-file command line argument to provide a value for this variable.

 ```

### Syntactical Errors

3. Modify `main.tf` to include something invalid. At the end of the file, add this:

 ```hcl
resource "aws_s3_bucket_object" "object" {
 ```

4. Clearly a syntax problem, so run a `plan` and you should see something like:

 ```
╷
│ Error: Unclosed configuration block
│
│   on main.tf line 9, in resource "aws_s3_bucket_object" "object":
│    9: resource "aws_s3_bucket_object" "object" {
│
│ There is no closing brace for this block before the end of the file. This may be caused by incorrect brace nesting elsewhere in this file.

```

 The goal is to get used to what things look like depending on the type of error encountered. These syntax
 errors happen early in the processing of Terraform commands.

### Validation Errors

This one might not be as clear as the syntax problem above. Let's pass something invalid to the AWS provider by setting a property that doesn't jive with the `aws_s3_bucket` resource as defined in the AWS provider.

5. We'll modify the syntax issue above slightly, so change your resource definition to be:

 ```hcl
resource "aws_s3_bucket" "bucket" {
  bucket_name     = local.bucket_name
  tags     = local.common_tags
}
 ```

 Nothing seemingly wrong with the above when looking at it, unless you know that the `bucket` property
is a required one for this type of resource, and not `bucket_name`.

 So, let's see what terraform tells us about this:

 ```bash
 terraform validate
 ```

 First, here we see the `terraform validate` command at work. We could just as easily do a `terraform plan`
and get a similar result. Two benefits of `validate`:

 1. It allows validation of things without having to worry about everything we would in the normal process of plan or apply. For example, variables don't need to be set.

 2. Related to the above, it's a good tool to consider for a continuous integration and/or delivery/deployment pipeline. Failing fast is an important part of any validation or testing tool.

 If you were to have run `terraform plan` here, you would've still been prompted for the `region` value
(assuming of course you haven't set it in otherwise).

 Having run `terraform validate` you should see immediately something like the following:

 ```
│ Error: Unsupported argument
│
│   on main.tf line 5, in resource "aws_s3_bucket" "bucket":
│    5:   bucket_name     = local.bucket_name
│
│ An argument named "bucket_name" is not expected here.

```

 So, our provider is actually giving us this. The AWS provider defines what a `aws_s3_bucket` should include, and what is required. The `bucket` property is required, so it's tell us we have a problem with this resource definition.

### Provider Errors or Passthrough

 And now to the most frustrating ones! These may be random, intermittent. They will be very specific to the provider and problems that happen when actually trying to do the work of setting up or maintaining your resources. Let's take a look at a simple example.

6. Modify the invalid resource we've been working with here in `main.tf` to now be:

 ```hcl
resource "aws_s3_object" "a_resource_that_will_fail" {
   bucket  = "a-bucket-that-doesnt-exist-or-i-dont-own"
   key     = "file"
   content = "This will never exist"
}
 ```

 and run `apply`. You should see something like:
 ```
│ Error: uploading S3 Object (file) to Bucket (a-bucket-that-doesnt-exist-or-i-dont-own): operation error S3: PutObject, https response error StatusCode: 404, RequestID: YC19QJ44SA49BK20, HostID: O9ksr7dpznRFjT4MF+gyaT90EJfsJtf1tucKpEFuayfwZK19GKCFJ4tKeSvJjHubLP9sA+VfhYc=, api error NoSuchBucket: The specified bucket does not exist
│
│   with aws_s3_object.a_resource_that_will_fail,
│   on main.tf line 9, in resource "aws_s3_object" "a_resource_that_will_fail":
│    9: resource "aws_s3_object" "a_resource_that_will_fail" {
│
```

 Where is this error actually coming from?

 In this case, it's the AWS API. It's trying to create a bucket object on a bucket that doesn't exist. Terraform is making the related API call to try and create the object, but AWS can't do it, so we get this error passed back to us.

 One other thing worth noting–Did everything fail?

 ```
random_integer.rand: Creating...
random_integer.rand: Creation complete after 0s [id=64673]
aws_s3_object.a_resource_that_will_fail: Creating...
aws_s3_bucket.bucket: Creating...
aws_s3_bucket.bucket: Still creating... [10s elapsed]
aws_s3_bucket.bucket: Still creating... [20s elapsed]
aws_s3_bucket.bucket: Creation complete after 23s [id=terraform-lab9-64673]

```

 Nope!

 Our real bucket was created.

 Terraform will complete what it can and fail on what it can't. Sometimes the solution to failures can sometimes just be running the same Terraform multiple times (e.g., if there's a network issue between where you're running Terraform and AWS).

### Finishing up

7. Fixing the offending HCL now in `main.tf`

 ```
resource "aws_s3_bucket" "bucket" {
  bucket     = local.bucket_name
  tags     = local.common_tags
}

resource "aws_s3_object" "a_resource_that_will_fail" {
   bucket  = aws_s3_bucket.bucket.id
   key     = "file"
   content = "This will never exist"
}
 ```

 and `destroy` (What happens if you fix the TF configuration and destroy before applying the new resource?)
