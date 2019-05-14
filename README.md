# Node-Video-API

The purpose of this repository is to provide a serverless API for use with a frontend web UI. At the current moment it does two things, returns all the contents of an S3 bucket and generates a pre-signed URL for access to the objects for authorized users (via AWS Cognito). This will likely be expanded upon as the React UI is built out and functionality is required. This API is implemented using AWS Lambda functions proxied by AWS API Gateway, and deployed via the command line using Terraform. In a later iteration, deployment will be facilitated by AWS CodePipeline.

## Getting Started

After cloning the repository to your local machine, the dependencies below must be installed locally in order to deploy the code to your AWS account.

### AWS

### Terraform

### NPM

### Node

## Planned Improvements

- CodePipeline integration
- Cognito integration for API Gateway
