# Installation instructions

## Windows

### Core requirements:

**AWS CLI**:

- The main steps are from https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

1) Download and run the AWS CLI MSI installer for Windows (64-bit):

https://awscli.amazonaws.com/AWSCLIV2.msi

2) Test executing the command:

`aws --version`

You should get as output the version of the AWS cli

**Git Bash**

1) Download from this link: https://github.com/git-for-windows/git/releases/download/v2.39.1.windows.1/Git-2.39.1-64-bit.exe

2) Install following the instructions.

**Terraform**


1) The best way is to use Chocolatey (https://chocolatey.org/install) and run:

`choco install terraform`

OR

1') But if you dont have nor use Chocolatey then first download from this link: https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_windows_amd64.zip

2) Extract into a new folder in your C drive (`c:\terraform`)

3) Add to PATH:

    - Select Control Panel and then System.
    - Click Advanced and then Environment Variables.
    - Double click the PATH variable
    - Add a new entry `c:\terraform`

4) Test by opening a new terminal and run:

`terraform -version`

6) You are set.

### How to check if everything works?

1) Create a directory in your User folder, let's call it tmp.

`mkdir tmp`

2) Create a file `providers.tf` with the following content

```
terraform {
  required_version = "~>1.4"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.20"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

3) Create a file `variables.tf` with the following content and change {student} for your username

```
variable "student_alias" {
  default = "{username}"
  description = "Location of the resource group."
}

```

4) Create a file `outputs.tf` with the following content

```
output "bucket" {
  value = aws_s3_bucket.student_buckets.id
}
```

5) Finally, create a file names `main.tf` with the following content:

```
resource "aws_s3_bucket" "student_buckets" {
  bucket        = "devint-${var.student_alias}"
  force_destroy = true
}
```

6) Run `terraform init` to initialize the providers

7) Run `terraform plan -out "test.tfplan"`, it should display that is going to create 2 resources (a random resource string and an actual resource group in azure)

8) Run `terraform apply "test.tfplan"`.

9) Verify it was OK because after applying the following command:

`terraform output bucket`

You get that name and run:

`aws s3 ls`

and it returns a resource.

10) Cleanup by running `terraform destroy`

## Mac

### Core requirements:

**AWS CLI**:

- The main steps are from https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

1) In your browser, download the macOS pkg file: https://awscli.amazonaws.com/AWSCLIV2.pkg

2) Test executing the command:

`aws --version`

You should get as output the version of the AWS cli

**Terraform**


1) The best way is to use Homebrew and run:

`brew install terraform`

OR

2) Test by opening a new terminal and run:

`terraform -version`

3) You are set.

### How to check if everything works?

1) Create a directory in your User folder, let's call it tmp.

`mkdir tmp`

2) Create a file `providers.tf` with the following content

```
terraform {
  required_version = "~>1.4"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.20"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

3) Create a file `variables.tf` with the following content and change {student} for your username

```
variable "student_alias" {
  default = "{username}"
  description = "Location of the resource group."
}

```

4) Create a file `outputs.tf` with the following content

```
output "bucket" {
  value = aws_s3_bucket.student_buckets.id
}
```

5) Finally, create a file names `main.tf` with the following content:

```
resource "aws_s3_bucket" "student_buckets" {
  bucket        = "devint-${var.student_alias}"
  force_destroy = true
}
```

6) Run `terraform init` to initialize the providers

7) Run `terraform plan -out "test.tfplan"`, it should display that is going to create 2 resources (a random resource string and an actual resource group in azure)

8) Run `terraform apply "test.tfplan"`.

9) Verify it was OK because after applying the following command:

`terraform output bucket`

You get that name and run:

`aws s3 ls`

and it returns a resource.

10) Cleanup by running `terraform destroy`
