output "vpc_id" {
  value = aws_vpc.dev_proj_1_vpc_eu_central_1.id
}
output "subnet_public_id" {
  value = aws_subnet.dev_proj_1_public_subnets.*.id
}