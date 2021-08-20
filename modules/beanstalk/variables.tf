variable "app_name" {}
variable "env_vars" {}
variable "key_name" {}
variable "security_group_elb_id" {}
variable "security_group_auto_scaling_id" {}
variable "cert_arn" {
  default = ""
}
variable "rds_username" {}
variable "rds_password" {}
variable "rds_db_name" {}
variable "rds_hostname" {}
variable "vpc_id" {}
variable "private_subnets" {}
variable "public_subnets" {}
variable "secret_key_base" {}
variable "iam_instance_profile_name" {}

variable "solution_stack_name" {}
variable "instance_type" {}
variable "autoscaling_min_size" {}
variable "autoscaling_max_size" {}