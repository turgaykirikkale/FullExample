resource "aws_cloudformation_stack" "cloud_formation" {
  name = var.cloud_formation_name

  template_body = file("./template.yaml")

  parameters = var.parameters

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
}
