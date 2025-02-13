
vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-west-2a", "us-west-2b"]
image_url = "183114607892.dkr.ecr.us-west-2.amazonaws.com/appointment-service:latest"
image_url_patient = "183114607892.dkr.ecr.us-west-2.amazonaws.com/patient-service:latest"