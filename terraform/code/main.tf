// TODO: Refactor backend state to take parameters: https://github.com/hashicorp/terraform/issues/13022

terraform {
  backend "s3" {
    bucket = "tf-backend-state-2019"
    key    = "node-video-api/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "${var.account_region}"
}

data "aws_caller_identity" "current" {}

module "iam" {
  source                        = "./modules/iam"
  get_s3_contents_arn           = "${aws_lambda_function.get_s3_contents.arn}"
  get_signed_url_arn            = "${aws_lambda_function.get_signed_url.arn}"
  s3_arn                        = "${aws_s3_bucket.node_video_api_content_bucket.arn}"
  api_gateway_id                = "${aws_api_gateway_rest_api.node_video_api_gatetway.id}"
  get_s3_contents_http_method   = "${aws_api_gateway_method.get_s3_contents_method.http_method}"
  get_s3_contents_resource_path = "${aws_api_gateway_resource.contents.path}"
  get_signed_url_http_method    = "${aws_api_gateway_method.get_signed_url_method.http_method}"
  get_signed_url_resource_path  = "${aws_api_gateway_resource.key.path}"
  account_id                    = "${data.aws_caller_identity.current.account_id}"
  account_region                = "${var.account_region}"
}

locals {
  env         = "${terraform.workspace}"
  tempDirPath = "../.."
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

  environment = {
    variables = {
      NODE_ENV = "${var.NODE_ENV}"
      bucket   = "${aws_s3_bucket.node_video_api_content_bucket.id}"
    }
  }
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

  environment = {
    variables = {
      NODE_ENV = "${var.NODE_ENV}"
      bucket   = "${aws_s3_bucket.node_video_api_content_bucket.id}"
    }
  }
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

/*
  --- API Gateways(s) --- 
*/

resource "aws_api_gateway_rest_api" "node_video_api_gatetway" {
  name        = "Node-Video-API"
  description = "The API Gateway for a series of lambda functions"
}

/*
  --- API Gateway Resource(s) --- 
*/

resource "aws_api_gateway_resource" "contents" {
  path_part   = "contents"
  parent_id   = "${aws_api_gateway_rest_api.node_video_api_gatetway.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.node_video_api_gatetway.id}"
}

resource "aws_api_gateway_resource" "url" {
  path_part   = "url"
  parent_id   = "${aws_api_gateway_rest_api.node_video_api_gatetway.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.node_video_api_gatetway.id}"
}

resource "aws_api_gateway_resource" "key" {
  path_part   = "{key}"
  parent_id   = "${aws_api_gateway_resource.url.id}"
  rest_api_id = "${aws_api_gateway_rest_api.node_video_api_gatetway.id}"
}

/*
  --- API Gateway Method(s) --- 
*/

resource "aws_api_gateway_method" "get_s3_contents_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.node_video_api_gatetway.id}"
  resource_id   = "${aws_api_gateway_resource.contents.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_signed_url_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.node_video_api_gatetway.id}"
  resource_id   = "${aws_api_gateway_resource.key.id}"
  http_method   = "GET"
  authorization = "NONE"

  request_parameters {
    "method.request.path.key" = true
  }
}

/*
  --- API Gateway Integration(s) --- 
*/

resource "aws_api_gateway_integration" "get_s3_contents_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.node_video_api_gatetway.id}"
  resource_id             = "${aws_api_gateway_resource.contents.id}"
  http_method             = "${aws_api_gateway_method.get_s3_contents_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.get_s3_contents.arn}/invocations"
}

resource "aws_api_gateway_integration" "get_signed_url_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.node_video_api_gatetway.id}"
  resource_id             = "${aws_api_gateway_resource.key.id}"
  http_method             = "${aws_api_gateway_method.get_signed_url_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.get_signed_url.arn}/invocations"
}
