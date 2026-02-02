output "ecr_web_url" {
  value = aws_ecr_repository.web.repository_url
}

output "ecr_mysql_url" {
  value = aws_ecr_repository.mysql.repository_url
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}