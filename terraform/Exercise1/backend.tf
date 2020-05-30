terraform {
  backend "s3" {
    bucket = "udacity-p2-performance-scalability"
    key = "terraform-backend/exercise1/terraform.tfstate"
    region = "us-east-1"
  }
}
