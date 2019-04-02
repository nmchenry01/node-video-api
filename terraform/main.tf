terraform {
  backend "s3" {
    bucket = "tf-backend-state-2019"
    key    = "node-video-api/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
