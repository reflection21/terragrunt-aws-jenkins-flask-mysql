#variables VPC
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR values"
}
variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}
variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}
variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}
#----------------------------------------------------------------------------------------------
#variables EC2-jenkins
variable "ec2_ami_id" {
  type        = string
  description = "DevOps Project 1 AMI Id for EC2 instance"
}
variable "public_key" {
  type        = string
  description = "Public key EC2"
}
