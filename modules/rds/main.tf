# Look up the latest minor/patch version of MySQL 8.0 dynamically
data "aws_rds_engine_version" "mysql" {
  engine  = "mysql"
  version = "8.0"
}


resource "aws_db_subnet_group" "db-subnet" {
  name       = var.db_sub_name
  subnet_ids = [var.private_sub_5a_id, var.private_sub_6b_id] 
}

resource "aws_db_instance" "db" {
  identifier              = "${var.project_name}-mydb-instance"
  engine                  = "mysql"
  engine_version          = data.aws_rds_engine_version.mysql.version
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  multi_az                = true
  storage_type            = "gp3"
  storage_encrypted       = true 
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0 

  vpc_security_group_ids = [var.db_sg_id]

  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  tags = {
    Name = "${var.project_name}-mydb"
  }
}


