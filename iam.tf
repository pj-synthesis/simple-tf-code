#region Orchistration Lambda
resource "aws_iam_role" "basic_lambda_role" {
  name = "basic_lambda_role"
  assume_role_policy = data.template_file.lambda_execution_role.rendered
}

# resource "aws_iam_policy" "lambda_policy" {
#   name        = local.orchestration_policy_name
#   description = "Allows Orchistration Lambda to Scan dynamodb and invoke lambda functions"

#   policy = data.template_file.lambda_policy.rendered
# }

# resource "aws_iam_policy_attachment" "orchestration_attachment" {
#   name       = "orchestration-attachment"
#   roles      = [aws_iam_role.basic_lambda_role.name]
#   policy_arn = aws_iam_policy.lambda_policy.arn
# }