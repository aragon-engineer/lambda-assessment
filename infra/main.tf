data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "hello" {
  function_name = "hello-lambda"

  role = "arn:aws:iam::163531628320:role/hello-lambda-exec-role"

  package_type = "Image"
  image_uri    = var.lambda_image_uri

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      CANDIDATE_NAME = var.candidate_name
    }
  }

  lifecycle {
    ignore_changes = [role]
  }

  tags = {
    Project = var.project_name
  }
}

resource "aws_lambda_function_url" "hello" {
  function_name      = aws_lambda_function.hello.function_name
  authorization_type = "NONE"
}
