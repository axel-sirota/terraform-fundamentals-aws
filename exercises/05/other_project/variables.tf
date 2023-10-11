# variables.tf

# Declare a variable so we can use it.
variable "region" {
  description = "Location of the resources"
  default     = "us-east-1"
}

variable "student_alias" {
  description = "Student Alias"
}