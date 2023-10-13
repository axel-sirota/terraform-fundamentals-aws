# variables.tf

# Declare a variable so we can use it.
variable "student_alias" {
  description = "Your student alias"
}

variable "region_alt" {
  description = "Alternative region"
  default     = "us-east-2"
}
