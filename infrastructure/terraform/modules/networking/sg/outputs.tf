output "jenkins_sg" {
  value       = aws_security_group.jenkins.id
  description = "jenkins sg"
}

output "jenkins_workers_sg" {
  value       = aws_security_group.jenkins_workers.id
  description = "jenkins workers sg"
}
