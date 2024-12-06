output "alarm_details" {
  description = "Details of the CloudWatch metric alarm"
  value = {
    name = aws_cloudwatch_metric_alarm.cloud_watch.alarm_name
    arn  = aws_cloudwatch_metric_alarm.cloud_watch.arn
    id   = aws_cloudwatch_metric_alarm.cloud_watch.id
  }
}
