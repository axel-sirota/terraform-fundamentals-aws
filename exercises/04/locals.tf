resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
  common_tags = {
    test    = "test"
    company = "Globomantics"
    Team    = "IT"
  }
  bucket_name = "${var.bucket_name_prefix}-${random_integer.rand.result}"
}
