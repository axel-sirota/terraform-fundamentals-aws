resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

locals {
  common_tags = {
    company = "Globomantics"
    Team    = "IT"
  }
  bucket_name = "${var.student_alias}-${random_integer.rand.result}"
}
