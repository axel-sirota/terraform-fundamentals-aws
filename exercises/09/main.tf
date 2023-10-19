# main.tf

# declare a resource stanza so we can create something.
resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  tags   = local.common_tags
}
