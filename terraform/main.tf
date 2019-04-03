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
  env         = "${terraform.workspace}"
  tempDirPath = "../temp"
}

resource "aws_lambda_function" "get_video_data" {
  filename      = "${local.tempDirPath}/get_video_data.zip"
  function_name = "Get-Video-Date-${local.env}"
  role          = ""                                        //TODO: Implement the IAM role
  handler       = "index.handler"

  source_code_hash = "${filebase64sha256("${local.tempDirPath}/get_video_data.zip")}"

  runtime     = "nodejs8.10"
  timeout     = 10
  memory_size = 128
}

resource "aws_lambda_function" "get_signed_url" {
  filename      = "${local.tempDirPath}/get_signed_url.zip"
  function_name = "Get-Signed-Url-${local.env}"
  role          = ""                                        //TODO: Implement the IAM role
  handler       = "index.handler"

  source_code_hash = "${filebase64sha256("${local.tempDirPath}/get_signed_url.zip")}"

  runtime     = "nodejs8.10"
  timeout     = 10
  memory_size = 128
}
