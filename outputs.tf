# Output VPC ID
output "vpc_id" {
  value = aws_vpc.goji.id
  description = "The ID of the VPC created."
}

output "public_subnet_1" {
  value       = aws_subnet.public_subnet_1.id
  description = "The ID of the public subnet 1."
}

output "public_subnet_2" {
  value       = aws_subnet.public_subnet_2.id
  description = "The ID of the public subnet 2."
}

output "private_subnet_1" {
  value       = aws_subnet.private_subnet_1.id
  description = "The ID of the private subnet 1."
}

output "private_subnet_2" {
  value       = aws_subnet.private_subnet_2.id
  description = "The ID of the private subnet 2."
}

