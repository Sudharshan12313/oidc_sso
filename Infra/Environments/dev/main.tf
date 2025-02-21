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
# LAMBDA Module
# ------------------------------

module "lamda" {
  source = "../../Modules/LAMDA"
  lambda_role_arn = module.iam.lambda_role_arn
  attach_basic_execution = module.iam.attach_basic_execution
}
