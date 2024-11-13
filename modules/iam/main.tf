resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = var.role
}

resource "aws_iam_policy" "policy" {
  name   = var.policy_name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
