output "dynamodb_table_name" {
  value = aws_dynamodb_table.basic-dynamodb-table.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.basic-dynamodb-table.arn
}