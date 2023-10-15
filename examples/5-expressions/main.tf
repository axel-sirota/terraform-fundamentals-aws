# main.tf

variable "env" {
  default = "prod"
}

resource "random_integer" "randomy" {
  min = 100000
  max = 999999
}

resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-example-5-${random_integer.randomy.result}"
  tags = {
    Ex  = "example-5"
    Env = var.env == "prod" ? "Production" : "Development"
  }
}

variable "for_map" {
  default = {
    "one" = 1
    "two" = 2
  }
}

resource "aws_s3_object" "object" {
  for_each = var.for_map
  key      = "tf-example-5-object-${each.value}"
  bucket   = aws_s3_bucket.bucket.id
  content  = "This file is from ${each.key}"
  tags = {
    Obj = "${upper("example-5")}-${each.key}"
    Env = var.env == "prod" ? "Production" : "Development"
  }
}
