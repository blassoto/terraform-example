variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "private_key_path" {}

variable "github_organization" {}
variable "github_repository" {}
variable "github_branch" {}
variable "github_token" {}

variable "db_password" {}

variable "app_name" {}

variable "secret_key_base" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "network_address_space" {}

variable "abs_domain_name" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "env_vars" {}

variable "abs_solution_stack_name" {}
variable "abs_instance_type" {}
variable "abs_autoscaling_min_size" {}
variable "abs_autoscaling_max_size" {}

variable "db_allocated_storage" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_username" {}
variable "db_storage_type" {}
variable "db_name" {}

variable "ec2_ami_owner" {}
variable "ec2_ami_name" {}
variable "ec2_ami_virtualization_type" {}
variable "ec2_instance_type" {}
variable "ec2_public_ip_address" {}