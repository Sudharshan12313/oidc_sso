

variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "image_name"{
default="010928202531.dkr.ecr.us-east-1.amazonaws.com/hackathon/helloworld:latest"
}

variable "lambda_role_arn" {
}

variable "attach_basic_execution" {
}
