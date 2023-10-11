
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

# declare a resource stanza so we can create something.

resource "aws_s3_object" "user_student_alias_object" {
  bucket  = data.terraform_remote_state.other_project.outputs.bucket_name
  key     = var.bucket_key
  content = "This bucket is reserved for ${var.student_alias}"
  tags    = data.terraform_remote_state.other_project.outputs.common_tags
}

# The following configuration is used to grab a generated s3 bucket name from a separate terraform project under the
# "other_project" folder.  tfstate files are provided for you for simplicity.

data "terraform_remote_state" "other_project" {
  backend = "local"
  config = {
    path = "other_project/terraform.tfstate"
  }
}