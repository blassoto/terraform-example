output "load_balancers" {
  value = aws_elastic_beanstalk_environment.production.load_balancers
}

output "application_name" {
  value = aws_elastic_beanstalk_application.app.name
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.production.name
}

output "endpoint_url" {
  value = aws_elastic_beanstalk_environment.production.endpoint_url
}

output "cname" {
  value = aws_elastic_beanstalk_environment.production.cname
}