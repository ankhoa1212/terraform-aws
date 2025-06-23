resource "aws_db_subnet_group" "db" {
  name       = "db-subnet-group"
  subnet_ids = var.db_subnet_ids
}

resource "aws_db_instance" "main" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [var.db_sg_id]
}
