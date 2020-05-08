provider "aws" {
        region = "us-east-1"
        version = "~> 2.57"
}



//S3 bucket
resource "aws_s3_bucket" "enterprise_backend_state" {
        bucket = "dev-application-name-backen-state-alfredete"
        //bucket = "application-name-backen-state"

        //con esto, prohibimos su destrucción, incluso con terraform destroy. Si queremos borrarlo, habrá que venir y quitar este código
        lifecycle {
                //prevent_destroy = true
                prevent_destroy = false

        }
        
        //es interesante versionar, para ver cómo ha evolucionado la infraestructura
        versioning {
                enabled = true
        }

        //hacemos que se encripte el contenido
        server_side_encryption_configuration {
                rule {
                        apply_server_side_encryption_by_default {
                                sse_algorithm = "AES256"
                        }
                }
        }
}



//Locking with Dynamo DB

resource "aws_dynamodb_table" "enterprise_backend_lock" {
        name= "dev-application-name-locks"

        //modo de cobro
        billing_mode = "PAY_PER_REQUEST"

        //es clave, of course
        hash_key = "LockID"

        //tenemos un dato en la BBDD
        attribute {
                name = "LockID"
                //tipo string
                type = "S"
        }
}