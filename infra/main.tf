# ──────────────────────────────────────────────
# Data
# ──────────────────────────────────────────────
data "aws_caller_identity" "current" {}

# ──────────────────────────────────────────────
# Lambda Function (container image)
# ──────────────────────────────────────────────
resource "aws_lambda_function" "hello" {
  function_name = var.project_name

  # Role 
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

  tags = {
    Project = var.project_name
  }
}

# ──────────────────────────────────────────────
# Lambda Function URL (public, no auth)
# ──────────────────────────────────────────────
resource "aws_lambda_function_url" "hello" {
  function_name      = aws_lambda_function.hello.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["GET"]
    max_age           = 86400
  }
}
