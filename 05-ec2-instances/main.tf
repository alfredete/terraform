provider "aws" {
        region = "us-east-1"
        version = "~> 2.58"
}

#queremos un servidor que sea accesible en el puerto 80 (web) y 22(ssh), desde cualquier lugar.
#hacia afuera queremos que pueda comunicar con cualquier parte
#para ello lo primero es crear un security_group, al que posteriormente pertenecerá el servidor
#la red virtual vpc_id debemos crearla anteriormente
resource "aws_security_group" "http_server_sg" {
        name ="http_server_sg"
        vpc_id = "vpc-6d8d8e17"

        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }


        egress {
                from_port = 0
                to_port = 0
                protocol = -1
                cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
                name = "http_server_sg"
        }
}