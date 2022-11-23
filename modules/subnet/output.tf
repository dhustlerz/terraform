
output "subnet" {
  value = aws_subnet.dev-subnet-1
}

output "security-group" {
  value = aws_default_security_group.myapp-sg
}
