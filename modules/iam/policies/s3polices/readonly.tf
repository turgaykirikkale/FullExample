resource "aws_iam_policy" "s3_read_only" {
  name        = "S3ReadOnlyAccess"
  description = "Provides read-only access to a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket" # Bucket listesini görüntüleme izni
        ]
        Resource = ["${var.s3_bucket_arn}", "${var.s3_bucket_arn}/*"]
      }
    ]
  })
}
