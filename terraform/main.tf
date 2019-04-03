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

module "iam" {
  source = "./modules/iam"
}

locals {
  env     = "${terraform.workspace}"
  tempDir = "../temp"
}

resource "aws_lambda_function" "get_video_data_lambda" {
  filename      = "${local.tempDir}/get_video_data_lambda.zip"
  function_name = "Get-Video-Data-${local.env}"
  role          = ""                                           // TODO: Implement IAM role
  handler       = "index.handler"

  source_code_hash = "${filebase64sha256("${local.tempDir}/get_video_data_lambda.zip")}"

  runtime = "nodejs8.10"
  timeout = 10

  tags = {
    "enviornment" = "${local.env}"
  }
}
