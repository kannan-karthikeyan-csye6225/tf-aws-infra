# modules/rds/main.tf

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "csye6225-db-subnet-group"
  description = "DB subnet group for RDS"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name = "csye6225-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  family = "postgres14"
  name   = "csye6225-db-parameter-group"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier        = "csye6225"
  engine            = "postgres"
  engine_version    = "14"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "csye6225"
  username = "csye6225"
  password = var.db_password

  storage_encrypted = true
  kms_key_id        = var.rds_kms_key_id

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  vpc_security_group_ids = [var.db_security_group_id]

  skip_final_snapshot = true
  publicly_accessible = false

  tags = {
    Name = "csye6225-rds"
  }
}