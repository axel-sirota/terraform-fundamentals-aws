output "bucket_name" {
  value = aws_s3_bucket.user_bucket.bucket
}

output "common_tags" {
  value = local.common_tags
}
