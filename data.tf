data "template_file" "lambda_execution_role" {
  template = file("${path.module}/policies/lambda_execution_role.json")
}