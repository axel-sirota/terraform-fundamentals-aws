# variables.tf

# Declare a variable so we can use it.
variable "student_alias" {
  description = "Your student alias"
}

variable "region" {
  default = "us-east-1"
}

variable "count_of_subnets" {
  type        = number
  description = "Amount of subnets within the VPC"
}

variable "vpc_cidr_range" {
  type        = string
  description = "CIDR Range of VPC to be created"
  default     = ""
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix of bucket name"
}

variable "vpc_name_prefix" {
  type        = string
  description = "Prefix of vpc name"
}

variable "subnets_name_prefix" {
  type        = string
  description = "Prefix of subnets name"
}
