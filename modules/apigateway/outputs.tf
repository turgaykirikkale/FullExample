# Output API Gateway Endpoint
output "api_endpoint" {
  value = aws_apigatewayv2_stage.lambda_stage.invoke_url
}
