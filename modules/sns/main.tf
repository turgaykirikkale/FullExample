resource "aws_sns_topic" "this" {
  count = var.sns_topic_name != null ? 1 : 0
  name  = var.sns_topic_name
}

resource "aws_sns_topic_policy" "this" {
  count = var.sns_topic_name != null ? 1 : 0
  arn   = aws_sns_topic.this[0].arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action   = "SNS:Publish",
        Resource = aws_sns_topic.this[0].arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" : var.s3_bucket_arn
          }
        }
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "email_subscription" {
  count     = var.notification_email != null ? 1 : 0
  topic_arn = aws_sns_topic.this[0].arn
  protocol  = "email"
  endpoint  = var.notification_email
}
