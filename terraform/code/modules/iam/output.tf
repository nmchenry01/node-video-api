output "get_s3_contents_lambda_role" {
  value = "${aws_iam_role.get_s3_contents_lambda_role.arn}"
}

output "get_signed_url_lambda_role" {
  value = "${aws_iam_role.get_signed_url_lambda_role.arn}"
}
