# variables.tf

# Declare a variable so we can use it.
variable "bucket_name_prefix" {
  description = "Prefix of name of bucket"
  default     = "bucket-terraform-lab4"
}

variable "bucket_key" {
  description = "Key of bucket object"
  default     = "terraform-lab4"
}

variable "student_alias" {
  description = "Your student alias"
}
