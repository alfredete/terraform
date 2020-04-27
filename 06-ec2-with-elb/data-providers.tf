#8      ahora intentaremos que no esté hardcoded el subnet
data "aws_subnet_ids" "default_subnets" {
  #lo anterior es la vpc sobre la qu elo queremos hacer
  vpc_id = aws_default_vpc.default.id
}
#9      ahora vamos a evitar el hardcoded el AMI. aws-linux-2-latest será un enlace dinámico a la ami que queramos, pero si se actualiza por cualquier cuestion, este enlace seguirá funcionando
data "aws_ami" "aws-linux-2-latest" {
  most_recent = true
  owners      = ["amazon"]
  #con lo anterior (y si el data fuera "aws_amiS"), se obtendrá una lista de ids de amis, ahora hay que filtrarlo para obtener exáctamente la que queremos
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

