variable "iam_user_name_prefix" {
        type = string #any, number, bool, list, map, set, object, tuple
        default = "my-iam-user"
}
provider "aws" {
        region = "us-east-1"
        version = "~> 2.58"
}
resource "aws_iam_user" "my_iam_users" {
        count= 3
        name = "${var.iam_user_name_prefix}-${count.index}"
}