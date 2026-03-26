output "lambda_function_url" {
  description = "Public URL of the Lambda Function"
  value       = aws_lambda_function_url.hello.function_url
}

output "ecr_repository_url" {
  description = "ECR repository URL (use as image prefix)"
  value       = aws_ecr_repository.lambda_repo.repository_url
}

output "github_actions_role_arn" {
  description = "IAM Role ARN to configure in GitHub Actions secrets"
  value       = aws_iam_role.github_actions.arn
}
 
