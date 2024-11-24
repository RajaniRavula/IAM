provider "aws" {
  region = "us-east-2"
}

# Create IAM Policy for full S3 and EC2 access
resource "aws_iam_policy" "s3_ec2_full_access" {
  name        = "S3EC2FullAccessPolicy"
  description = "Policy to allow full access to S3 and EC2 resources"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "arn:aws:s3:::your-bucket-name/*"
      },
      {
        Effect   = "Allow"
        Action   = "ec2:*"
        Resource = "*"
      }
    ]
  })
}

# Create IAM Role that allows users to assume it
resource "aws_iam_role" "user_assume_role" {
  name = "UserAssumeRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:PrincipalTag/Role" = "S3EC2FullAccess"
          }
        }
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_s3_ec2_policy_to_role" {
  role       = aws_iam_role.user_assume_role.name
  policy_arn = aws_iam_policy.s3_ec2_full_access.arn
}

# Create 4 IAM Users
resource "aws_iam_user" "user1" {
  name = "User1"
}

resource "aws_iam_user" "user2" {
  name = "User2"
}

resource "aws_iam_user" "user3" {
  name = "User3"
}

resource "aws_iam_user" "user4" {
  name = "User4"
}

# Attach Role to IAM Users by creating an IAM Role Policy Attachment for each user
resource "aws_iam_user_policy_attachment" "user1_policy_attachment" {
  user       = aws_iam_user.user1.name
  policy_arn = aws_iam_policy.s3_ec2_full_access.arn
}

resource "aws_iam_user_policy_attachment" "user2_policy_attachment" {
  user       = aws_iam_user.user2.name
  policy_arn = aws_iam_policy.s3_ec2_full_access.arn
}

resource "aws_iam_user_policy_attachment" "user3_policy_attachment" {
  user       = aws_iam_user.user3.name
  policy_arn = aws_iam_policy.s3_ec2_full_access.arn
}

resource "aws_iam_user_policy_attachment" "user4_policy_attachment" {
  user       = aws_iam_user.user4.name
  policy_arn = aws_iam_policy.s3_ec2_full_access.arn
}

output "iam_role_arn" {
  value = aws_iam_role.user_assume_role.arn
}

output "iam_users" {
  value = [
    aws_iam_user.user1.name,
    aws_iam_user.user2.name,
    aws_iam_user.user3.name,
    aws_iam_user.user4.name
  ]
}

output "iam_policy_arn" {
  value = aws_iam_policy.s3_ec2_full_access.arn
}

