# main.tf

# declare a resource stanza so we can create something.
resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  tags   = local.common_tags
}

resource "aws_s3_object" "user_student_alias_object" {
  bucket  = aws_s3_bucket.bucket.bucket
  key     = var.bucket_key
  content = "This bucket is reserved for ${var.student_alias}"
  tags    = local.common_tags
}