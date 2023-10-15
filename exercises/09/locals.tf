resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
  common_tags = {
    company = "Globomantics"
    Team    = "IT"
  }
  bucket_name = "${var.bucket_prefix}-${random_integer.rand.result}"
}
