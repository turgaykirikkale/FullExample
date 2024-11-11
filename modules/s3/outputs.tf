output "bucket_name" {
  value       = aws_s3_bucket.s3_bucket_001.bucket
  description = "Name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.s3_bucket_001.arn
  description = "arn of the bucket"
}

output "bucket_id" {
  value       = aws_s3_bucket.s3_bucket_001.id
  description = "ID of the bucket"
}
