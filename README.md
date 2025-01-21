# terraform-aws-static-site

Terraform code for creating infrastructure on AWS for a Jekyll or any other static website.

**Note:** The majority of the code is based on the following repositories:
- [pirxthepilot/terraform-aws-static-site](https://github.com/pirxthepilot/terraform-aws-static-site)
- IAM-related parts are derived from [brianmacdonald/terraform-aws-s3-static-site](https://github.com/brianmacdonald/terraform-aws-s3-static-site)

## Features

- Deploys almost everything needed to host a static website.
- Uses the apex domain for the main URL (e.g., `https://example.com`).
- Supports multiple subdomains, which redirect to the apex domain.
- Keeps your S3 bucket private—only CloudFront can access it via Origin Access Identity (OAI).
- Includes a URL rewrite function to append `index.html` to the URI, enabling CloudFront to serve paths like `https://example.com/foo`, not just `https://example.com`.
- Outputs the CloudFront distribution ID, AWS Access Key, and AWS Secret Key for use in automated deployments.
- Terraform state is saved in an S3 bucket.

## Description

This Terraform code creates the following AWS resources for your static website:

- S3 bucket
- Requisite IAM roles and bucket access policies
- S3 Origin Access Identity (OAI)
- Route53 DNS records
- TLS certificates (with DNS validation)
- CloudFront distribution
- CloudFront function for redirect and rewrite rules

### Limitations

This code does **not** deploy the following:

- Your domain's Route53 zone. You must manually configure this and provide the zone ID to use with this module.

## Usage

Let's create the S3 state bucket (please use a unique one, as this one might already be taken), which will be used for the Terraform state:
```
aws s3api create-bucket --bucket "myblog-tf-state" --region "us-east-1" --acl private --profile prod
```

If necessary, update the bucket name in `main.tf`.

In the Terraform variables file, `blog.tfvars`, configure at least the following. It is assumed that the AWS profile name prod is used for this deployment.

```
domain          = "my-site.com"
route53_zone_id = "Z00XXXXXXXXXXXX"
subdomains      = ["www"]
```

### Description of variables:

- `domain` - Your site's domain (e.g., `example.com`).
- `subdomains` (optional) - A list of subdomains to configure. All subdomains will redirect to the apex domain URL. Default: `[]` (no subdomains).
- `route53_zone_id` - The Route53 zone ID for your domain.
- `block_ofac_countries` (optional) - Whether to block OFAC-sanctioned countries. Default: `false`.
- `cache_ttl` (optional) - CloudFront cache TTL values. See [variables.tf](./variables.tf) for default values.

### Run the code

Using OpenTofu:

```
tofu init
tofu plan -var-file="blog.tfvars"
tofu apply -var-file="blog.tfvars"
```

Or using Terraform:

```
terraform init
terraform plan -var-file="blog.tfvars"
terraform apply -var-file="blog.tfvars"
```

### Complete manual to deploy Jekyll using pipelines and infrastructure managed in Terraform.

[jekyll-terraform-gitlab-pipeline](https://cyberpunk.tools/jekyll/update/2024/12/19/jekyll-terraform-gitlab-pipeline.html)
