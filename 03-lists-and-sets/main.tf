variable "names" {
  default = ["ranga", "tom", "jane"]
}
provider "aws" {
  region  = "us-east-1"
  version = "~> 2.58"
}
resource "aws_iam_user" "my_iam_users" {
  #count = length(var.names)
  #name = var.names[count.index]
  #si usamos count, el índice es numérico, por lo que las variaciones en el orden hacen que todo se tenga que hacer d enuevo
  #si usamos for_each, el índice es el propio valor, por lo que los cambios no afectan a los que ya existen
  for_each = toset(var.names)
  name     = each.value
}