output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "vpc id"
}

output "jenkins_subnet_id" {
  value       = [for s in aws_subnet.jenkins : s.id]
  description = "jenkin subnet id"
}


output "jenkins_workers_subnet_id" {
  value       = [for s in aws_subnet.jenkins_workers : s.id]
  description = "jenkin workers subnet id"
}


output "jenkins_subnet_cidr" {
  value       = [for s in aws_subnet.jenkins : s.cidr_block]
  description = "jenkin subnet id"
}


output "jenkins_workers_subnet_cidr" {
  value       = [for s in aws_subnet.jenkins_workers : s.cidr_block]
  description = "jenkin workers subnet id"
}
  
