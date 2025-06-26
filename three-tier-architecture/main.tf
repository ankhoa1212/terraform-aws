module "core" {
  source = "./modules/core"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  db_subnet_cidrs      = ["10.0.5.0/24", "10.0.6.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
  access_ip            = "0.0.0.0/0" # Change this to your IP or CIDR block for security
}

module "web" {
  source = "./modules/web"

  public_subnet_ids  = module.core.public_subnet_ids
  web_alb_sg_id      = module.core.web_alb_sg_id
  web_instance_sg_id = module.core.web_instance_sg_id
  web_ami            = "ami-05ffe3c48a9991133"
  web_instance_type  = "t2.micro"
  vpc_id             = module.core.vpc_id
}

module "app" {
  source = "./modules/app"

  private_subnet_ids = module.core.private_subnet_ids
  app_alb_sg_id      = module.core.app_alb_sg_id
  app_instance_sg_id = module.core.app_instance_sg_id
  app_ami            = "ami-05ffe3c48a9991133"
  app_instance_type  = "t2.micro"
  vpc_id             = module.core.vpc_id
}

module "database" {
  source = "./modules/database"

  db_subnet_ids = module.core.db_subnet_ids
  db_sg_id      = module.core.db_sg_id
  db_name       = "mydb"
  db_user       = "admin"
  db_password   = "securepassword123"
}

module "bastion" {
  source = "./modules/bastion"

  bastion_ami = "ami-05ffe3c48a9991133"
  bastion_instance_type = "t2.micro"
  bastion_sg   = module.core.bastion_sg_id
  key_name     = "web-server"
  public_subnets = module.core.public_subnet_ids
}