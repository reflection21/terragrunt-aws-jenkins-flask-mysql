terraform {
  backend "s3" {
    bucket = "reflectionbucket21"
    key    = "devops-project-1/jenkins/terraform.tfstate"
    region = "eu-central-1"
  }
}
