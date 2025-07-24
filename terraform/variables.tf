variable "env" {
  type = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "ecs_task_execution_role" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "ecr_repo_url" {
  description = "ECR repository URL for the container image"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
}
