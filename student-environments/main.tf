terraform {
  required_version = ">=1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.20"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5.1"
    }
  }
}

provider "aws" {
  region  = "us-west-1"
  profile = "diaxel"
}

resource "random_integer" "rand" {
  max = 10000
  min = 1
}

resource "aws_s3_bucket" "student_buckets" {
  count         = length(var.students)
  bucket        = "devint-${var.students[count.index].name}-${random_integer.rand.result}"
  force_destroy = true
}


resource "aws_iam_account_password_policy" "students" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}

resource "aws_iam_user" "students" {
  count         = length(var.students)
  name          = var.students[count.index].name
  force_destroy = true
}

resource "aws_iam_access_key" "tests" {
  count      = length(var.students)
  user       = var.students[count.index].name
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_user_login_profile" "students" {
  count                   = length(var.students)
  user                    = var.students[count.index].name
  password_length         = 10
  pgp_key                 = var.pgp_key
  password_reset_required = false
  lifecycle {
    ignore_changes = [password_length, password_reset_required, pgp_key]
  }
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_policy" "student_bucket_access" {
  count       = length(var.students)
  name        = "${var.students[count.index].name}StudentBucketAccess"
  description = "Allowing student access to their own bucket"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBase",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowListMyBucket",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::devint-${var.students[count.index].name}",
                "arn:aws:s3:::devint-${var.students[count.index].name}-*"
            ]
        },
        {
            "Sid": "AllowAllInMyBucket",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::devint-${var.students[count.index].name}/*",
              "arn:aws:s3:::devint-${var.students[count.index].name}-*/*"
            ]
        }
    ]
}
EOF

  depends_on = [aws_iam_user.students]
}



resource "aws_iam_policy" "student_ec2_access" {
  depends_on  = [aws_iam_user.students]
  name        = "StudentEC2Access"
  description = "Allowing student access to EC2 accordingly"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAllOnEC2",
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "OnlyAllowCertainInstanceTypesToBeCreated",
            "Effect": "Deny",
            "Action": [
                "ec2:RunInstances"
            ],
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "ForAnyValue:StringNotLike": {
                    "ec2:InstanceType": [
                        "*.nano",
                        "*.small",
                        "*.micro",
                        "*.medium"
                    ]
                }
            }
        },
        {
            "Sid": "AllowAllELB",
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Sid": "AllowAllAutoscaling",
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}


resource "aws_iam_policy" "student_ssm_get_access" {
  depends_on  = [aws_iam_user.students]
  name        = "StudentSSMAccess"
  description = "Allowing student access to SSM accordingly"
  policy      = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Action":[
            "ssm:DescribeParameters"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action":[
            "ssm:GetParameter*"
        ],
        "Resource": "arn:aws:ssm:us-east-1::parameter/*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "kms:Decrypt"
        ],
        "Resource": "arn:aws:kms:us-east-1::key/*"
    }
]
}
EOF
}

resource "aws_iam_policy" "student_credentials_access" {
  depends_on  = [aws_iam_user.students]
  name        = "StudentIAMCredentialsAccess"
  description = "Allowing student to rotate and manage their own credentials"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers",
                "iam:GetAccountPasswordPolicy"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:*AccessKey*",
                "iam:ChangePassword",
                "iam:GetLoginProfile",
                "iam:GetUser",
                "iam:*ServiceSpecificCredential*",
                "iam:*SigningCertificate*"
            ],
            "Resource": ["arn:aws:iam::*:user/$${aws:username}"]
        }
    ]
}
EOF
}


resource "aws_iam_policy" "student_roles_access" {
  depends_on  = [aws_iam_user.students]
  name        = "StudentIAMRolesAccess"
  description = "Allowing student to create and assign roles "
  policy      = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"iam:CreatePolicy",
				"iam:CreateInstanceProfile",
				"iam:DeleteInstanceProfile",
				"iam:GetRole",
				"iam:PassRole",
                "iam:TagRole",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:TagInstanceProfile",
                "iam:PutRolePolicy",
                "iam:GetInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:DeleteRolePolicy",
				"iam:GetPolicy",
				"iam:DeletePolicy",
				"iam:CreateRole",
				"iam:DeleteRole",
				"iam:GetRolePolicy",
				"iam:AddRoleToInstanceProfile"
			],
			"Resource": [
				"arn:aws:iam::535146832369:policy/*",
				"arn:aws:iam::535146832369:role/*",
				"arn:aws:iam::535146832369:instance-profile/*"
			]
		},
		{
			"Effect": "Allow",
			"Action": [
				"iam:ListPolicies",
				"iam:ListRoles"
			],
			"Resource": "*"
		}
	]
}
EOF
}

resource "aws_iam_user_policy_attachment" "student_bucket_access" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = aws_iam_policy.student_bucket_access.*.arn[count.index]
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "student_ec2_access" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = aws_iam_policy.student_ec2_access.arn
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "student_credentials_access" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = aws_iam_policy.student_credentials_access.arn
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "student_ssm_access_attachment" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = aws_iam_policy.student_ssm_get_access.arn
  depends_on = [aws_iam_user.students]
}
resource "aws_iam_user_policy_attachment" "student_roles_attachment" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = aws_iam_policy.student_roles_access.arn
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "cloud9_user_access" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloud9User"
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "dynamodb_user_access" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "vpc_user_access" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "s3_user_access" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  depends_on = [aws_iam_user.students]
}
resource "aws_iam_user_policy_attachment" "ec2_user_access" {
  count      = length(var.students)
  user       = var.students[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  depends_on = [aws_iam_user.students]
}


