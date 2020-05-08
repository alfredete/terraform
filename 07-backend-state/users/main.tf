variable application_name {
        default = "07-backend-state"
}

variable project_name {
        default = "users"
}

variable environment {
        default = "dev"
}


terraform {
        backend "s3" {
                bucket = "dev-application-name-backen-state-alfredete"
                //cada aplicación que utilice ese backend tendrá un fichero y un lock en dynamodb
                //key = "${var.environment}-${var.application_name}-${var.project_name}"
                //key = "dev-07-backend-state-users"
                key = "dev/07-backend-state/users"
                region = "us-east-1"
                dynamodb_table = "dev-application-name-locks"
                encrypt = true
        }
}

provider "aws" {
        region = "us-east-1"
        version = "~> 2.57"
}

resource "aws_iam_user" "my_iam_user" {
        name = "my-iam-user-abc"
}