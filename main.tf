provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

module "network" {
  source = "./modules/network"
  aws_region = var.aws_region
  network_address_space = var.network_address_space
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
}

module "rds" {
  source = "./modules/rds"
  username = var.db_username
  password = var.db_password
  security_group_ids = [module.network.security_group_id]
  subnet_group_name = module.network.db_subnet_group
  allocated_storage = var.db_allocated_storage
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  identifier = var.db_name
  name = var.db_name
  storage_type = var.db_storage_type
}

module "beanstalk" {
  source = "./modules/beanstalk"
  app_name = var.app_name
  # cert_arn = module.route53.cert_arn
  env_vars = var.env_vars
  iam_instance_profile_name = module.policy.iam_instance_profile_name
  key_name = var.key_name
  private_subnets = module.network.private_subnets
  public_subnets = module.network.public_subnets
  rds_db_name = module.rds.rds_db_name
  rds_hostname = module.rds.rds_hostname
  rds_password = module.rds.rds_password
  rds_username = module.rds.rds_username
  secret_key_base = var.secret_key_base
  security_group_auto_scaling_id = module.network.security_group_auto_scaling_id
  security_group_elb_id = module.network.security_group_elb_id
  vpc_id = module.network.vpc_id
  solution_stack_name = var.abs_solution_stack_name
  instance_type = var.abs_instance_type
  autoscaling_min_size = var.abs_autoscaling_min_size
  autoscaling_max_size = var.abs_autoscaling_max_size
}

/*
module "route53" {
  source = "./modules/route53"
  domain_name = var.domain_name
  load_balancer = module.beanstalk.load_balancers[0]
}
*/

module "codepipeline" {
  source = "./modules/codepipeline"
  app_name = var.app_name
  iam_role_build_arn = module.policy.iam_role_build_arn
  application_name = module.beanstalk.application_name
  environment_name = module.beanstalk.environment_name
  github_branch = var.github_branch
  github_organization = var.github_organization
  github_repository = var.github_repository
  github_token = var.github_token
}

module "policy" {
  source = "./modules/policy"
  app_name = var.app_name
  s3_bucket_artifacts_id = module.codepipeline.s3_bucket_artifacts_id
  bucket_artifacts_arn = module.codepipeline.bucket_artifacts_arn
}

/*
module "ses" {
  source = "./modules/ses"
  domain_name = var.domain_name
  route53_zone_id = module.route53.route53_zone_id
}
*/

module "bastion" {
  source = "./modules/ec2"
  key_name = var.key_name
  public_subnets = module.network.public_subnets
  vpc_id = module.network.vpc_id
  name = "bastion"
  aws_ami_owner = var.ec2_ami_owner
  aws_ami_name = var.ec2_ami_name
  aws_ami_virtualization_type = var.ec2_ami_virtualization_type
  instance_type = var.ec2_instance_type
  public_ip_address = var.ec2_public_ip_address
}