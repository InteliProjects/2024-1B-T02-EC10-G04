resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for DB Host"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name     = "db_sg"
    menageBy = "Terraform"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Security group for Backend Host"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name     = "backend_sg"
    menageBy = "Terraform"
  }

}

resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Security group for Redis cluster"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name     = "redis-sg"
    menageBy = "Terraform"
  }
}