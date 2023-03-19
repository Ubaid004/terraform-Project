terraform {
        required_providers{
        aws = {
        source = "hashicorp/aws"
        version = ">= 2.13.0"
}
}
required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my-s3-bucket" {
  bucket_prefix = var.bucket_prefix
  acl = var.acl

   versioning {
    enabled = var.versioning
  }

  tags = var.tags
}

resource "aws_vpc" "terra-vpc" {
        cidr_block= var.vpc_cidr
        tags= {
                Name= var.vpc_name
}
}
