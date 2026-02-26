output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
}

output "private_dev_subnet_ids" {
  value = [aws_subnet.private_dev_az1.id, aws_subnet.private_dev_az2.id]
}

output "private_prod_subnet_ids" {
  value = [aws_subnet.private_prod_az1.id, aws_subnet.private_prod_az2.id]
}

output "workspace_security_group_id" {
  value = aws_security_group.workspace.id
}