output "vpc_id" {
  description = "Prints out the VPC ID for the deployed resource"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  value = {
    for subnet_name in keys(local.public_subnets) : subnet_name => {
      id = aws_subnet.this[subnet_name].id
      az = aws_subnet.this[subnet_name].availability_zone
    }
  }
}

output "private_subnets" {
  value = {
    for subnet_name in keys(local.private_subnets) : subnet_name => {
      id = aws_subnet.this[subnet_name].id
      az = aws_subnet.this[subnet_name].availability_zone
    }
  }
}
