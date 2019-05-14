/*
  --- IAM Policy Data Document(s) --- 
*/

data "aws_iam_policy_document" "get_s3_contents_lambda_policy_document" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${var.s3_arn}",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "get_signed_url_lambda_policy_document" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "${var.s3_arn}",
      "${var.s3_arn}/*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

/*
  --- IAM Policies ---  
*/

resource "aws_iam_policy" "get_s3_contents_lambda_policy" {
  name        = "get-s3-contents-lambda-policy-${terraform.workspace}"
  description = "A policy that allows a lambda function to list the contents of an S3 bucket"
  policy      = "${data.aws_iam_policy_document.get_s3_contents_lambda_policy_document.json}"
}

resource "aws_iam_policy" "get_signed_url_lambda_policy" {
  name        = "get-signed-url-lambda-policy-${terraform.workspace}"
  description = "A policy that allows a lambda function to generate a signed url for an object in an S3 bucket"
  policy      = "${data.aws_iam_policy_document.get_signed_url_lambda_policy_document.json}"
}

/*
  --- IAM Roles --- 
*/

resource "aws_iam_role" "get_s3_contents_lambda_role" {
  name               = "get-s3-contents-lambda-role-${terraform.workspace}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role_policy_document.json}"
}

resource "aws_iam_role" "get_signed_url_lambda_role" {
  name               = "get-signed-url-lambda-role-${terraform.workspace}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role_policy_document.json}"
}

/*
  --- Policy/Role Attachement ---
*/

resource "aws_iam_policy_attachment" "get_s3_contents_lambda_attachment" {
  name       = "get-s3-contents-lambda-attachment-${terraform.workspace}"
  roles      = ["${aws_iam_role.get_s3_contents_lambda_role.name}"]
  policy_arn = "${aws_iam_policy.get_s3_contents_lambda_policy.arn}"
}

resource "aws_iam_policy_attachment" "get_signed_url_lambda_attachment" {
  name       = "get-signed-url-lambda-attachment-${terraform.workspace}"
  roles      = ["${aws_iam_role.get_signed_url_lambda_role.name}"]
  policy_arn = "${aws_iam_policy.get_signed_url_lambda_policy.arn}"
}

/*
  --- Lambda Permission(s) ---
*/

resource "aws_lambda_permission" "get_s3_contents_lambda_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.get_s3_contents_arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.account_region}:${var.account_id}:${var.api_gateway_id}/*/${var.get_s3_contents_http_method}${var.get_s3_contents_resource_path}"
}

resource "aws_lambda_permission" "get_signed_url_lambda_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.get_signed_url_arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.account_region}:${var.account_id}:${var.api_gateway_id}/*/${var.get_signed_url_http_method}${var.get_signed_url_resource_path}"
}
