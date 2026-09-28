output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_sub_1a_id" {
  value = aws_subnet.public_sub_1a.id
}
output "public_sub_2b_id" {
  value = aws_subnet.public_sub_2b.id
}
output "private_sub_3a_id" {
  value = aws_subnet.private_sub_3a.id
}

output "private_sub_4b_id" {
  value = aws_subnet.private_sub_4b.id
}

output "private_sub_5a_id" {
  value = aws_subnet.private_sub_5a.id
}

output "private_sub_6b_id" {
    value = aws_subnet.private_sub_6b.id 
}

output "igw_id" {
    value = aws_internet_gateway.igw
}