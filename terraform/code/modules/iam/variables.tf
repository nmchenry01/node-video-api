variable "get_s3_contents_arn" {
  type        = "string"
  description = "The ARN (Amazon Resource Name) of the Get-S3-Contents Lambda function"
}

variable "get_signed_url_arn" {
  type        = "string"
  description = "The ARN (Amazon Resource Name) of the Get-Signed-Url Lambda function"
}

variable "s3_arn" {
  type        = "string"
  description = "The ARN (Amazon Resource Name) of the S3 bucket"
}

variable "api_gateway_id" {
  type        = "string"
  description = "The ID of the API Gateway"
}

variable "get_s3_contents_http_method" {
  type        = "string"
  description = "The HTTP Method for the get_s3_contents method associated with the equivalent Lambda function"
}

variable "get_s3_contents_resource_path" {
  type        = "string"
  description = "The complete path for this API resource, including all parent paths"
}

variable "account_id" {
  type        = "string"
  description = "The AWS account id"
}

variable "account_region" {
  type        = "string"
  description = "The AWS region for deployment"
}
