provider "aws" {
  region   = "ap-south-1"
  profile  = "terrauser"
}

resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow MySQL Port"
  ingress {
    description = "allow_sql_port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "task-sgroup"
  }
}

resource "aws_db_instance" "wp_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "gaurav123"
  vpc_security_group_ids = [ aws_security_group.allow_mysql.id ]
  publicly_accessible  = true
  iam_database_authentication_enabled = true
  skip_final_snapshot  = true
}