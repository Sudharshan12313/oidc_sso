 terraform{
   backend "s3" {
     bucket         = "52297389-bucket-1"
     key            = "dev/terraform/EKS/terraform.tfstate"
     region         = "us-east-1"
     encrypt        = true
   }
 }



