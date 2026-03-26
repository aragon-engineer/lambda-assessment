variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used as prefix for all resource names"
  type        = string
  default     = "hello-lambda"
}

variable "candidate_name" {
  description = "Candidate name shown in the Lambda response"
  type        = string
  default     = "José Miguel Aragón"
}

variable "lambda_image_uri" {
  description = "Full ECR image URI (repo:tag) for the Lambda function"
  type        = string
}

variable "github_org" {
  description = "GitHub organization or user that owns the repository"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

