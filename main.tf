terraform {
        required_providers {
        aws = { 
        source  = "hashicorp/aws"
        version = ">= 2.13.0"
    }
  }
required_version = ">= 1.2.0"
}

provider "aws" {
        region = var.aws_region
}



#------------
# Buckets
#------------


resource "aws_s3_bucket" "my-s3-bucket" {
  bucket_prefix = var.bucket_prefix
  acl = var.acl

   versioning {
    enabled = var.versioning
  }

  tags = var.tags_bt
}




resource "aws_s3_bucket_object" "object"{
        for_each= fileset("html/","*")
        bucket= aws_s3_bucket.my-s3-bucket.id
        key= each.value
        source= "html/${each.value}"
        etag= filemd5("html/${each.value}")
        content_type= "text/html"
}

#------------
# VPC
#------------

resource "aws_vpc" "terra-vpc" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
        Name = var.name
}
}

#------------
# Internet Gateway
#------------

resource "aws_internet_gateway" "terra-GW" {
  count = var.create_vpc && var.create_igw ? 1 : 0

  vpc_id = aws_vpc.terra-vpc[0].id
  tags   = merge({ "ResourceName" = "igw-${var.name}" }, var.tags)

}

#------------
# LB
#------------


resource "aws_lb" "terra" {
  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_load_balancer_type
  security_groups    = var.lb_security_groups
  subnets            = var.lb_subnets

  enable_deletion_protection = var.lb_enable_deletion_protection #true
  tags = merge({ "Name" = var.lb_name }, var.tags)
}

resource "aws_lb_target_group" "terra" {
  name        = "tg-${var.lb_name}"
  port        = var.lb_target_port
  protocol    = var.lb_protocol    #"HTTP"
  target_type = var.lb_target_type #"ip" for ALB/NLB, "instance" for autoscaling group,
  vpc_id      = "vpc-07c2c5e049d981990"
  tags        = merge({ "Name" = "tg-${var.lb_name}" }, var.tags)
  depends_on  = [aws_lb.terra]
}

resource "aws_lb_listener" "terra" {
  load_balancer_arn = aws_lb.terra.arn
  port              = var.lb_listener_port     #"443"
  protocol          = var.lb_listener_protocol #"TLS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terra.arn
  }
}


#----------------
# Auto Scalling
#----------------

resource "aws_autoscaling_group" "terra" {

  name                      = var.as_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type #"ELB" or default EC2
  vpc_zone_identifier = var.lb_subnets
  target_group_arns   = [aws_lb_target_group.terra.arn] #var.target_group_arns

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_instance.instance.id
    version = "$Latest"
  }

  depends_on = [aws_lb.terra]
}

#---------------
# scale up policy
#---------------
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.as_name}-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.terra.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}


#---------------
# scale up alarm
#---------------

# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.as_name}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30" # New instance will be created once CPU utilization is higher than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.terra.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}


#---------------
# scale down policy
#---------------

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.as_name}-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.terra.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

#------------------
# scale down alarm
#------------------
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.as_name}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.terra.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}

