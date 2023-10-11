data "aws_s3_bucket" "selected" {
  bucket = aws_s3_bucket.my_bucket.bucket
}

# Create bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-tf-test-bucket-${var.student_alias}"
  tags = {
    Name        = "My bucket from ${var.student_alias}"
    Environment = "Dev"
  }
}
