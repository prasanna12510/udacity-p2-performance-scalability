terraform {
  backend "s3" {
    bucket = "terraform-backend-stj"
    key = "udacity/cand/p2e2/terraform.tfstate"
    region = "us-east-1"
  }
}
