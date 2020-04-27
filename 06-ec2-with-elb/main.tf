provider "aws" {
  region  = "us-east-1"
  version = "~> 2.58"
}

#7      esto es una forma de no hardcodear el id de la vpc. Solamente es una referencia. No se crea ni se destruye en realidad.
#referencciará a la vpc por defecto de la region que estemos usando.
resource "aws_default_vpc" "default" {
}

#1      queremos un servidor que sea accesible en el puerto 80 (web) y 22(ssh), desde cualquier lugar.
#hacia afuera queremos que pueda comunicar con cualquier parte
#para ello lo primero es crear un security_group, al que posteriormente pertenecerá el servidor
#la red virtual vpc_id debemos crearla anteriormente
resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  #vpc_id = "vpc-6d8d8e17"
  #7    como hemos creado la default_vpc, ya la podemos referenciar en este lugar. Queremos el id, así que lo referenciamos (podemos buscarlo en el tfstate o en la console)
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  #ami           = "ami-0323c3dd2da7fb37d"
  #9    ahora ya podemos quitar el hardcodeo con esto
  ami = data.aws_ami.aws-linux-2-latest.id

  key_name      = "default-ec2"
  instance_type = "t2.micro"
  #2      saco el id del security group anterior, ejecutando antes y copiandolo del terraform.tfstate, o lo puedo enlazar directamente
  #con los identificadores del grupo definido anterior de esta forma:
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  #3      para obtener la subnet, me voy en el portal al servicio VPC, miro la red que cree antes, en este caso vpc_id, y selecciono subnets.
  #se habrá generado una subnet por cada availability zone. Selecciono una y ya está.
  #subnet_id = "subnet-164eb970"

  #8    Ahora podemos usar la referencia al data de las subnets para elegir una de ellas
  /*PS C:\Az\Terraform\05-ec2-instances> terraform console
                                                                > data.aws_subnet_ids.default_subnets
                                                                {
                                                                "id" = "vpc-6d8d8e17"
                                                                "ids" = [
                                                                "subnet-164eb970",
                                                                "subnet-2f2cd10e",
                                                                "subnet-32f1593c",
                                                                "subnet-5fd6ec61",
                                                                "subnet-a8d254e5",
                                                                "subnet-f68370a9",
                                                                ]
                                                                "vpc_id" = "vpc-6d8d8e17"
                                                                }
                                                                
                                                                > data.aws_subnet_ids.default_subnets.ids[0]

                                                                > 
                                                                Error: Invalid index

                                                                on <console-input> line 1:
                                                                (source code not available)

                                                                This value does not have any indices.

                                                                > tolist(data.aws_subnet_ids.default_subnets.ids)[0]
                                                                subnet-164eb970
                                                                                                                                
                                                                                                                                
   No devuelve una lista, sino un set, por lo que hay que convertirlo en lista antes                 */
  subnet_id = tolist(data.aws_subnet_ids.default_subnets.ids)[0]

  #4      Ahora queremos subir un pequeño html al servidor para poder acceder a él, para ello haremos una connection:
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    #5      Una de las cosas que necesitaremos será la clave para conectarnos PEM que habremos descargado al general el key_pair
    #para ello, al inicio del fichero añadimos la variable con la ruta al key_pair
    private_key = file(var.aws_key_pair)
  }
  #6 ahora ejecutaremos un remote-exec, que es básicamente como ejecutar en línea de comandos en la instancia remota. Hay que tener en cuenta
  #que estos aprovisionamientos solo se pueden hacer al crear el resource y no se permite al actualizarlo. Habría que destruirlo y volverlo a crear
  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                                                                 //install httpd
      "sudo service httpd start",                                                                                                                  //start
      "echo Welcome to this Terraform course master of the universe - Virtual server is at ${self.public_dns} | sudo tee /var/www/html/index.html" //copy a file
    ]
  }
}