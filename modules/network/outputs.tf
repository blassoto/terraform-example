output "db_subnet_group" {
  value = aws_db_subnet_group.default.name
}

output "security_group_id" {
  value = aws_security_group.allow_postgresql.id
}

output "security_group_elb_id" {
  value = aws_security_group.elb.id
}

output "private_subnets" {
  value = module.main-vpc.private_subnets
}

output "public_subnets" {
  value = module.main-vpc.public_subnets
}

output "vpc_id" {
  value = module.main-vpc.vpc_id
}

output "security_group_auto_scaling_id" {
  value = aws_security_group.auto_scaling.id
}