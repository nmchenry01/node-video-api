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
  source              = "./modules/iam"
  get_s3_contents_arn = "${aws_lambda_function.get_s3_contents.arn}"
  get_signed_url_arn  = "${aws_lambda_function.get_signed_url.arn}"
}

locals {
  env         = "${terraform.workspace}"
  tempDirPath = "../temp"
}

/*
  AWS Lambda Function(s)
*/

resource "aws_lambda_function" "get_s3_contents" {
  filename      = "${local.tempDirPath}/get_s3_contents.zip"
  function_name = "Get-Video-Date-${local.env}"
  role          = ""                                         //TODO: Implement the IAM role
  handler       = "index.handler"

  source_code_hash = "${filebase64sha256("${local.tempDirPath}/get_s3_contents.zip")}"

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
