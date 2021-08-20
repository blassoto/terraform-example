output "iam_role_build_arn" {
  value = aws_iam_role.build.arn
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.build.name
}