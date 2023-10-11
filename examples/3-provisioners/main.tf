# Create bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = local.bucket_name
  tags = {
    Name        = local.bucket_name
    Environment = "Dev"
  }
  provisioner "local-exec" {
    command = "echo ${aws_s3_bucket.my_bucket.arn} >> bucket.txt"
  }
}

resource "null_resource" "first-run" {
  provisioner "local-exec" {
    command = "echo 'This runs first'"
  }
}
