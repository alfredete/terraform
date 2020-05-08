variable "environment" {
        default = "default"
}

provider "aws" {
        region = "us-east-1"
        version = "~> 2.57"
}

resource "aws_iam_user" "my_iam_user" {
        name = "${local.iam_user_extension}-${var.environment}"
}

//variables específicas del módulo y no pueden ser sobreescritas desde fuera
locals {
        iam_user_extension  = "my-iam-user-abc"
}