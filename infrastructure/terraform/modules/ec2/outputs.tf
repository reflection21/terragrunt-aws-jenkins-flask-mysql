output "jenkins_master" {
  value       = [for s in aws_instance.jenkins : s.id]
  description = "jenkins master id"
}

output "app_instance" {
  value       = [for s in aws_instance.flask_instance : s.id]
  description = "app instance id"
}
