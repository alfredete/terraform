provider "aws" {
        region = "us-east-1"
        version = "~> 2.57"
}

resource "aws_s3_bucket" "my_s3_bucket" {
        bucket = "my-s3-bucket-alfredete-002"
        versioning {
                enabled = true
        }
}

resource "aws_iam_user" "my_iam_user" {
        name = "my-iam-user-abc-updated"
}

output "my_s3_bucket_versioning" {
        value = aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}

output "my_s3_bucket_complete_details" {
        value = aws_s3_bucket.my_s3_bucket
}

output "aws_iam_user_complete_details" {
        value = aws_iam_user.my_iam_user
}