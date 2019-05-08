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
  s3_arn              = "${aws_s3_bucket.node_video_api_content_bucket.arn}"
}

locals {
  env         = "${terraform.workspace}"
  tempDirPath = "../temp"
}

/*
  --- Lambda Function(s) ---
*/

resource "aws_lambda_function" "get_s3_contents" {
  filename      = "${local.tempDirPath}/get_s3_contents.zip"
  function_name = "Get-S3-Contents-${local.env}"
  role          = "${module.iam.get_s3_contents_lambda_role}"
  handler       = "index.handler"

  source_code_hash = "${filebase64sha256("${local.tempDirPath}/get_s3_contents.zip")}"

  runtime     = "nodejs8.10"
  timeout     = 10
  memory_size = 128
}

resource "aws_lambda_function" "get_signed_url" {
  filename      = "${local.tempDirPath}/get_signed_url.zip"
  function_name = "Get-Signed-Url-${local.env}"
  role          = "${module.iam.get_signed_url_lambda_role}"
  handler       = "index.handler"

  source_code_hash = "${filebase64sha256("${local.tempDirPath}/get_signed_url.zip")}"

  runtime     = "nodejs8.10"
  timeout     = 10
  memory_size = 128
}

/*
  --- S3 Bucket(s) --- 
*/

resource "aws_s3_bucket" "node_video_api_content_bucket" {
  bucket = "node-video-api-content"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
