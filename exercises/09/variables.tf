# variables.tf

# Declare a variable so we can use it.
variable "region" {
  description = "Location of the resources"
}

variable "bucket_prefix" {
  description = "Bucket name prefix"
  default     = "terraform-lab9"
}
