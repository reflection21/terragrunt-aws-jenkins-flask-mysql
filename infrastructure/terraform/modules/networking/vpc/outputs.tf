output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "vpc id"
}

output "public_subnet_id" {
  value       = [for s in aws_subnet.public : s.id]
  description = "jenkin subnet id"
}

output "jenkins_subnet_cidr" {
  value       = [for s in aws_subnet.jenkins : s.cidr_block]
  description = "jenkin subnet cidr"
}

output "jenkins_subnet_id" {
  value       = [for s in aws_subnet.jenkins : s.id]
  description = "jenkin subnet id"
}
  
  
output "app_subnets" {
  value       = [for s in aws_subnet.app : s.id]
  description = "app subnets id"
}