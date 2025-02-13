# ------------------------------
# VPC Module
# ------------------------------
# module "vpc" {
#   source              = "../../Modules/VPC"
#   vpc_cidr            = var.vpc_cidr
#   public_subnets      = var.public_subnets
#   private_subnets     = var.private_subnets
#   availability_zones  = var.availability_zones
# }

# ------------------------------
# IAM Module
# ------------------------------
module "iam" {
  source = "../../Modules/IAM"
  
}

# ------------------------------
# ECR Module
# ------------------------------
module "ecr" {
  source    = "../../Modules/ECR"
  # repo_name = var.repo_name
}

# ------------------------------
# EKS Module (Cluster & Node Group)
# ------------------------------

module "lamda" {
  source = "../../Modules/LAMDA"
  lambda_role_arn = module.iam.lambda_role_arn
  attach_basic_execution = module.iam.attach_basic_execution
}