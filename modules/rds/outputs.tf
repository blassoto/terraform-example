output "rds_username" {
  value = aws_db_instance.rds-app-prod.username
}

output "rds_password" {
  value = aws_db_instance.rds-app-prod.password
}

output "rds_db_name" {
  value = aws_db_instance.rds-app-prod.name
}

output "rds_hostname" {
  value = aws_db_instance.rds-app-prod.address
}