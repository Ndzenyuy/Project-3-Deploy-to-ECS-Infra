# ECS Infrastructure

Deploy containerized apps on AWS ECS Fargate with RDS.

## Architecture
- VPC: 3 public + 3 private subnets across 3 AZs
- ALB in public subnets
- ECS Fargate in public subnets (no NAT gateway)
- RDS in private subnets
- ECR for container images

## Usage
1. Copy terraform.tfvars.example to terraform.tfvars
2. Update db_password and other values
3. Run: terraform init && terraform apply

## Outputs
- alb_dns_name: Access your application
- ecr_repository_url: Push Docker images
- rds_endpoint: Database connection
