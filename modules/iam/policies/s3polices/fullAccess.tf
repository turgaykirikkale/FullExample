resource "aws_iam_policy" "s3_full_access" {
  name        = "S3FullAccess"
  description = "Allows full access to a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "${var.s3_bucket_arn}/*"
      }
    ]
  })
}
