provider "aws" {
  profile = "default"
  region = "eu-west-3"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "pepperflash-bucket-training"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}
