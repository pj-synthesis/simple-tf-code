#region local vars
locals {
  basic_lambda_payload_path = "${path.module}/lambda-sources/${var.lambda_function_name}/${var.lambda_function_name}.zip"
  basic_lambda_source_dir   = "${path.module}/lambda-sources/${var.lambda_function_name}"

  #basic_lambda_base64sha256_files = filebase64sha256("${local.basic_lambda_source_dir}/basic.py")

  basic_lambda_base64sha256_files = base64sha256(join("", tolist([
    file("${local.basic_lambda_source_dir}/basic.py"),
    file("${path.module}/lambda.tf"),
    file("${path.module}/iam.tf"),
  ])))
}

# Dummy resource to ensure archive is created at apply stage
# resource null_resource dummy_trigger {
#   triggers = {
#     timestamp = timestamp()
#   }
# }

# data "local_file" "py_main" {
#   filename = "${path.module}/lambda-sources/${var.lambda_function_name}/${var.lambda_function_name}.py"
#   depends_on = [
#   # Make sure archive is created in apply stage
#     null_resource.dummy_trigger
#   ]
# }

# data "local_file" "py_req" {
#   filename = "${path.module}/lambda-sources/${var.lambda_function_name}/requirements.txt"
#   depends_on = [
#   # Make sure archive is created in apply stage
#     null_resource.dummy_trigger
#   ]
# }


data "archive_file" "basic_lambda_source" {
  depends_on  = [null_resource.pip]
  type        = "zip"
  source_dir  = local.basic_lambda_source_dir
  output_path = local.basic_lambda_payload_path
  # source_dir  = local.basic_lambda_source_dir

  # source {
  #   content  = data.local_file.py_main.content
  #   filename = "${var.lambda_function_name}.py"
  # }

  # source {
  #   content  = data.local_file.py_req.content
  #   filename = "requirements.txt"
  # }
}

resource "null_resource" "pip" {
  provisioner "local-exec" {
    command = "pip install -r requirements.txt --ignore-installed --target ."

    working_dir = local.basic_lambda_source_dir
  }

  triggers = {
    main = local.basic_lambda_base64sha256_files
  }
}

resource "null_resource" "data_delay" {
  depends_on = [null_resource.pip]

  provisioner "local-exec" {
    command = "sleep 10"
  }

  triggers = {
    main = local.basic_lambda_base64sha256_files
  }
}

# resource "aws_lambda_function" "test_lambda" {
#   # If the file is not in the current working directory you will need to include a 
#   # path.module in the filename.
#   filename      = local.basic_lambda_payload_path
#   function_name = var.lambda_function_name
#   description   = "A basic lambda function"
#   role          = aws_iam_role.basic_lambda_role.arn
#   handler       = "basic.main"
#   timeout       = 30
#   memory_size   = 128
#   publish       = true
#   # The filebase64sha256() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
#   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#   source_code_hash = local.basic_lambda_base64sha256_files #filebase64sha256("${local.basic_lambda_payload_path}")

#   runtime = "python3.9"

#   environment {
#     variables = {
#       foo = "bar"
#     }
#   }
# }
