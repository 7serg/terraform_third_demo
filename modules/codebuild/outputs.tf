

output "codebuild_name" {
  value = aws_codebuild_project.my_app.name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
