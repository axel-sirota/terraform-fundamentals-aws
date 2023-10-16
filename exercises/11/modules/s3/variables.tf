# variables.tf

# Declare a variable so we can use it.

variable "bucket_name" {
  type        = string
  description = "Bucket name"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
}