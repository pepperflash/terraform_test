terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region = "eu-west-3"
}


resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "pepperflash-bucket-training"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name = "prod_web" 
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "True"
  }
}

resource "aws_instance" "prod_bastion" {
  ami           = "ami-05d3997b49b54fa92"
  instance_type = "t2.nano"
  
  vpc_security_group_ids = [
  aws_security_group.prod_web.id]

   tags = {
    "Terraform" : "True"
  }
}

resource "aws_eip" "prod_web"{
  instance = aws_instance.prod_bastion.id

  tags = {
    "Terraform" : "True"
  }

}

