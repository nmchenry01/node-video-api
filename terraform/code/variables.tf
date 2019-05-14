// TODO: Add new variables to support parameterized remote state

variable "account_region" {
  type        = "string"
  description = "The AWS region for deployment"
}

variable "NODE_ENV" {
  type        = "string"
  description = "The node enviornment for the lambda functions"
}
