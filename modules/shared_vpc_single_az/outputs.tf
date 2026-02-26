output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_dev_subnet_id" {
  value = aws_subnet.private_dev.id
}

output "private_prod_subnet_id" {
  value = aws_subnet.private_prod.id
}

output "workspace_security_group_id" {
  value = aws_security_group.workspace.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}