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

resource "aws_lb" "terra-lb" {
        name  = var.lb_name
        internal = var.lb_internal
        load_balancer_type = var.lb_load_balancer_type
        security_groups = var.security_groups
        subnets = var.lb_subnets
        enable_deletion_protection = var.lb_enable_deletion_protection

        tags= merge({ "Name" = var.lb_name }, var.lb_tags)
}

resource "aws_lb_target_group" "terra-lb" {
        name        = var.lb_name
        port        = var.lb_target_port
        protocol    = var.lb_protocol
        target_type = var.lb_target_type #"ip" for ALB/NLB, "instance" for autoscalling
        vpc_id      = var.lb_vpc_id
        tags        = merge({ "Name" = "tg-${var.lb_name}" }, var.lb_tags)
        depends_on  = [aws_lb.terra-lb]
}

resource "aws_lb_listener" "this" {
        load_balancer_arn = aws_lb.terra-lb.arn
        port              = var.lb_listener_port
        protocol          = var.lb_listener_protocol
        default_action {
                type             = "forward"
                target_group_arn = aws_lb_target_group.terra-lb.arn
  }
}

resource "aws_s3_bucket_object" "object"{
        for_each= fileset("html/","*")
        bucket= aws_s3_bucket.my-s3-bucket.id
        key= each.value
        source= "html/${each.value}"
        etag= filemd5("html/${each.value}")
        content_type= "text/html"

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
