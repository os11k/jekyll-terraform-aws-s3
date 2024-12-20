output "CLOUDFRONT_DISTRIBUTION_ID" {
  value = aws_cloudfront_distribution.static_site.id
}

output "S3_BUCKET" {
  value = aws_s3_bucket.static_site.id
}

output "AWS_ACCESS_KEY_ID" {
  sensitive   = true
  description = "The AWS Access Key ID for the IAM deployment user."
  value       = aws_iam_access_key.deploy.id
}

output "AWS_SECRET_ACCESS_KEY" {
  sensitive   = true
  description = "The AWS Secret Key for the IAM deployment user."
  value       = aws_iam_access_key.deploy.secret
}
