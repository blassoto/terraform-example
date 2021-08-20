resource "aws_db_instance" "rds-app-prod" {
  allocated_storage    = 10
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  identifier           = var.identifier
  name                 = var.name
  username             = var.username
  password             = var.password
  db_subnet_group_name = var.subnet_group_name
  multi_az             = "false"
  vpc_security_group_ids = var.security_group_ids
  storage_type         = var.storage_type
  backup_retention_period = 30
  skip_final_snapshot = true

  tags = {
    Name = "rds-appprod"
  }
}
