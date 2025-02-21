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
}

# ------------------------------
# LAMBDA Module
# ------------------------------

module "lamda" {
  source = "../../Modules/LAMDA"
  lambda_role_arn = module.iam.lambda_role_arn
  attach_basic_execution = module.iam.attach_basic_execution
  image_name = var.image_name
}
