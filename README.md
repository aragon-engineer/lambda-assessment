# Hello Lambda — Assessment Submission

**Candidate:** José Miguel Aragón  
**Stack:** Python · AWS Lambda (container) · Terraform · GitHub Actions (OIDC)

---

## Architecture

GitHub repo
    │
    └── GitHub Actions (OIDC → AWS)
            │
            ├── flake8 + bandit (lint & security)
            ├── Docker build → ECR push
            ├── Terraform plan
            └── Terraform apply
                    │
                    ├── ECR Repository
                    ├── IAM Role (Lambda execution)
                    ├── IAM OIDC Provider (GitHub)
                    ├── IAM Role (GitHub Actions, least-privilege)
                    ├── Lambda Function (container image)
                    └── Lambda Function URL (public HTTPS endpoint)

---

## Repository Structure

.
├── app/
│   ├── handler.py
│   ├── requirements.txt
│   └── Dockerfile
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── .github/
│   └── workflows/
│       └── deploy.yml
├── .flake8
└── README.md

---

## Prerequisites

### 1. AWS – Bootstrap (one-time trust setup)

To enable secure communication between GitHub Actions and AWS using OIDC, a one-time bootstrap step is required.

This step establishes the trust relationship and creates the foundational resources (IAM roles and ECR repository). After this, all deployments are fully automated.

cd infra

terraform init

terraform apply \
  -var="lambda_image_uri=placeholder" \
  -var="github_org=YOUR_GH_ORG" \
  -var="github_repo=YOUR_GH_REPO" \
  -target=aws_iam_openid_connect_provider.github \
  -target=aws_iam_role.github_actions \
  -target=aws_iam_role_policy.github_actions \
  -target=aws_ecr_repository.lambda_repo \
  -target=aws_iam_role.lambda_exec \
  -target=aws_iam_role_policy_attachment.lambda_basic_execution

Retrieve the role ARN:

terraform output github_actions_role_arn

### 2. GitHub – Repository secrets

| Secret | Value |
|---|---|
| AWS_ROLE_ARN | ARN from the step above |

---

## CI/CD Pipeline

| Job | Trigger | What it does |
|---|---|---|
| lint | Every push / PR | flake8 + bandit (security scan) |
| build | After lint | Builds Docker image and pushes to ECR |
| terraform-plan | After build | terraform init + validate + plan |
| terraform-apply | Push to main only | terraform apply + outputs URL |

All deployments are fully automated after the bootstrap step.

No long-lived AWS credentials are used — authentication is handled via short-lived OIDC tokens.

---

## Local Development

cd app
python -c "import handler, json; print(json.dumps(handler.lambda_handler({}, {}), indent=2))"

docker build -t hello-lambda ./app
docker run -p 9000:8080 hello-lambda
curl -X POST http://localhost:9000/2015-03-31/functions/function/invocations -d '{}'

---

## Design Decisions

| Decision | Rationale |
|---|---|
| Terraform over CDK | Reproducible, declarative, easy to review |
| OIDC over access keys | Eliminates long-lived credentials |
| Container image | Ensures consistency across environments and simplifies dependency management |
| Lambda Function URL | Simplest public endpoint |
| bandit + flake8 | Early security and quality checks |

---

## AI Tooling Usage

AI was used to accelerate development in:

- Initial scaffolding
- Terraform boilerplate
- CI/CD workflow generation
- Lint troubleshooting
- Documentation drafting

All outputs were reviewed and validated manually.

---

## Scalability Considerations

This implementation was intentionally kept simple, but it can evolve into a reusable deployment pattern (“golden path”) for teams.

The structure supports:

- Multi-environment deployments (dev/staging/prod)
- Modular Terraform reuse
- Standardized CI/CD pipelines
- Reduced configuration drift across environments
- Integration with API Gateway + WAF for production-grade security

---

## Live Endpoint

cd infra && terraform output lambda_function_url

Test:
curl $(cd infra && terraform output -raw lambda_function_url)

Response:

{
  "message": "Hello from José Miguel Aragón",
  "status": "ok"
}
