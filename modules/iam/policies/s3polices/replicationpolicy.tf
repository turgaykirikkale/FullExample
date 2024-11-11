resource "aws_iam_role_policy" "s3_replication_policy" {
  name = "s3-replication-policy-crr"
  role = var.role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
        ]
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:GetObjectVersion"
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "${var.s3_bucket_arn}/*"
      }
    ]
  })
}
