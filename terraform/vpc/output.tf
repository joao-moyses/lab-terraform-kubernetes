output "vpc_id" {
  value = aws_vpc.kubernetes.id
}


output "subnet_private_1a" {
  value = aws_subnet.private.id
}


output "subnet_private_1b" {
  value = aws_subnet.private1.id
}


output "subnet_public_1a" {
  value = aws_subnet.public.id
}


output "subnet_public_1b" {
  value = aws_subnet.public1.id
}


output "subnet_rds_1a" {
  value = aws_subnet.rds.id
}

output "subnet_rds_1b" {
  value = aws_subnet.rds1.id
}

output "internet_gateway" {
  value = aws_internet_gateway.gw.id
}