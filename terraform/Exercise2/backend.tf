terraform {
  backend "s3" {
    bucket = "udacity-p2-performance-scalability"
    key = "terraform-backend/exercise2/terraform.tfstate"
    region = "us-east-1"
  }
}
