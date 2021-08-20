resource "aws_iam_user" "user" {
  name = var.app_name
}

resource "aws_iam_user_policy" "user-policy" {
  name = "user-policy"
  user = aws_iam_user.user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "keys" {
  user = aws_iam_user.user.name
}

resource "aws_elastic_beanstalk_application" "app" {
  name        = var.app_name
  description = var.app_name
}

resource "aws_elastic_beanstalk_environment" "production" {
  name                = "production"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = var.solution_stack_name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "RAILS_ENV"
    value = "production"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "SECRET_KEY_BASE"
    value = var.secret_key_base
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.security_group_auto_scaling_id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = var.iam_instance_profile_name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = var.autoscaling_min_size
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = var.autoscaling_max_size
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${element(var.private_subnets, 0)},${element(var.private_subnets, 1)},${element(var.private_subnets, 2)},${element(var.public_subnets, 0)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${element(var.public_subnets, 0)},${element(var.public_subnets, 1)},${element(var.public_subnets, 2)}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "30"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "RDS_USERNAME"
    value = var.rds_username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "RDS_PASSWORD"
    value = var.rds_password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "RDS_DATABASE"
    value = var.rds_db_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "RDS_HOSTNAME"
    value = var.rds_hostname
  }

  setting {
    namespace = "aws:elbv2:listener:default"
    name = "ListenerEnabled"
    value = "true" // For SSL: Set this value in false and uncomment the following commented setting code
  }

  setting {
    namespace = "aws:elbv2:listener:default"
    name = "Protocol"
    value = "HTTP" # TCP for Network load balancer and HTTP for Application load balancer
  }

//  setting {
//    namespace = "aws:elbv2:listener:443"
//    name = "ListenerEnabled"
//    value = "true"
//  }

//  setting {
//    namespace = "aws:elbv2:listener:443"
//    name = "Protocol"
//    value = "TCP"
//  }

//  setting {
//    namespace = "aws:elbv2:listener:443"
//    name = "SSLCertificateArns"
//    value = var.cert_arn
//  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = var.security_group_elb_id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    value = var.key_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_ACCESS_KEY_ID"
    value     = aws_iam_access_key.keys.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_SECRET_ACCESS_KEY"
    value     = aws_iam_access_key.keys.secret
  }

  dynamic "setting" {
    for_each = var.env_vars

    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }
}

// Uncommento for HTTP to HTTPS Redirect
//resource "aws_lb_listener" "front_end" {
//  load_balancer_arn = aws_elastic_beanstalk_environment.production.load_balancers[0]
//  port              = "80"
//  protocol          = "HTTP"
//
//  default_action {
//    type = "redirect"
//
//    redirect {
//      port        = "443"
//      protocol    = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
//}
