provider "aws" {
  alias  = "destination"
  region = var.destination_region
  //aws access key and secret key will come here
}

resource "aws_s3_bucket" "destination_bucket" {
  provider      = aws.destination
  bucket        = var.destination_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "destination_versioning" {
  provider = aws.destination
  bucket   = aws_s3_bucket.destination_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


# Replication  IAM role
resource "aws_iam_role" "s3_replication_role" {
  name = "s3-replication-role-${var.source_bucket_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3_replication_policy" {
  role = aws_iam_role.s3_replication_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ReplicateObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:GetBucketVersioning"
        ]
        Effect = "Allow"
        Resource = [
          "${var.source_bucket_arn}",
          "${aws_s3_bucket.destination_bucket.arn}",
          "${aws_s3_bucket.destination_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Replication Konfigürasyonu
resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = var.source_bucket_id
  role   = aws_iam_role.s3_replication_role.arn

  depends_on = [
    aws_s3_bucket_versioning.destination_versioning
  ]

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.destination_bucket.arn
      storage_class = "STANDARD" # target storage clss

    }

  }
}


