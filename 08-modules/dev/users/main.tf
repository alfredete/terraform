module "user_module" {
    source = "../../terraform-modules/users"
    //le damos valor a la variable que ha definida en el modulo
    environment = "dev"
    //si la variable está definida como locals, no se podrá sobreescribir
}