provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "doorfeed-dev-app-bucket"
  acl    = "private"
}

output "bucket_name" {
  value = aws_s3_bucket.app_bucket.id
}
