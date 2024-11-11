resource "aws_s3_bucket" "s3_bucket_001" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_notification" "s3_notification" {
  bucket = aws_s3_bucket.s3_bucket_001.id

  dynamic "topic" {
    for_each = var.sns_topic_arn != null ? [var.sns_topic_arn] : []
    content {
      topic_arn = topic.value
      events    = var.s3_events
    }
  }
}


//public access block control
resource "aws_s3_bucket_public_access_block" "PAB" {
  bucket = aws_s3_bucket.s3_bucket_001.id

  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}


// VERSIONING SETTING 

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket_001.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
    //status = "Suspended" this close to versioning.
  }
}

# The SNS email subscription will be created only if both sns_topic_arn and notification_email are provided.
resource "aws_sns_topic_subscription" "email_subscription" {
  count     = var.notification_email != null ? 1 : 0
  topic_arn = var.sns_topic_arn
  protocol  = "email"
  endpoint  = var.notification_email
}


