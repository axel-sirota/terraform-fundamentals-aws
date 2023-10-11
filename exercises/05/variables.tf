# Declare a variable so we can use it.
variable "student_alias" {
  description = "Your student alias"
}
variable "bucket_key" {
  description = "Key to object in bucket"
  default     = "terraform-lab5-di"
}
