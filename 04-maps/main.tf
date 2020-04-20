variable "users" {
  type = map
  default = {
    ravs : { country : "Netherlands", department : "ABC" },
    tom : { country : "US", department : "DEF" },
    jane : { country : "India", department : "GHI" }
  }
}
provider "aws" {
  region  = "us-east-1"
  version = "~> 2.58"
}
resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name     = each.key
  #country: each.value
  tags = {
    country : each.value.country
    department : each.value.department
  }
}