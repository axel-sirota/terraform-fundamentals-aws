# main.tf

# declare a resource stanza so we can create something.
resource "aws_s3_bucket" "user_bucket" {
  bucket = local.bucket_name
}
