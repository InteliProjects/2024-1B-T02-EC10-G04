resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]

  tags = {
    name     = "db_subnet_group"
    menageBy = "Terraform"
  }
}

resource "aws_db_instance" "main_postgresql_db" {
  identifier             = "prod-db"
  engine                 = "postgres"
  engine_version         = "16.2"
  username               = "postgres"
  db_name                = "prod"
  instance_class         = "db.t3.micro"
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  allocated_storage      = 20
  multi_az               = false
  password               = "postgres123"
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  tags = {
    name     = "prod-db"
    menageBy = "Terraform"
  }
}

