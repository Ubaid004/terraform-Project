# -------------------------------------------
# Common Variables
# -------------------------------------------

variable "aws_region" {
  description = "AWS infrastructure regio"
  type        = string
  default     = "ap-south-1"
}

variable "tags" {
  description = "Tag map for the resource"
  type        = map(string)
  default     = {}
}




# -------------------------------------------
# bucket Variables
# -------------------------------------------


variable "bucket_prefix" {
    type        = string
    description = "(required since we are not using 'bucket') Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
    default     = "my-s3bucket-"
}

variable "tags_bt" {
    type        = map
    description = "(Optional) A mapping of tags to assign to the bucket."
    default     = {
        environment = "DEV"
        terraform   = "true"
    }
}

variable "versioning" {
    type        = bool
    description = "(Optional) A state of versioning."
    default     = true
}

variable "acl" {
    type        = string
    description = " Defaults to private "
    default     = "private"
}


# -------------------------------------------
# VPC Variables
# -------------------------------------------

variable "create_vpc" {
  description = "decision to create VPC"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "terra-vpc"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}


# -------------------------------------------
# Internet Gateway Variables
#-------------------------------------------

variable "create_igw" {
  description = "decision to create IGW"
  type        = bool
  default     = false
}


# -------------------------------------------
# Security Group
# -------------------------------------------

variable "sg_name" {
  description = "sg_name"
  type        = string
  default     = "terra-sg"
}

variable "app_port" {
  description = "app_port"
  type        = number
  default     = 443
}

variable "aws_vpc_id" {
  description = "aws_vpc_id"
  type        = string
  default     = ""
}

variable "allow_all_ips" {
  description = "allow_all_ips"
  type        = string
  default     = "0.0.0.0/0"
}

variable "aws_vpc_main_cidr_block" {
  description = "aws_vpc_main_cidr_block"
  type        = list(string)
  default     = []
}
# -------------------------------------------
# Loab Balancer
# -------------------------------------------

variable "lb_name" {
  description = "LB name"
  type        = string
  default     = "Mylb"
}

variable "lb_internal" {
  description = "Internal true or false"
  type        = bool
  default     = false
}

variable "lb_load_balancer_type" {
  description = "Application or Network type LB"
  type        = string
  default     = "application"
}

variable "lb_security_groups" {
  description = "LB security groups"
  type        = list(string)
  default     = ["sg-07b9d22bfeeb2bbd6"]
}

variable "lb_subnets" {
  description = "LB subnets"
  type        = list(string)
  default     = ["subnet-08efb067b0c124552", "subnet-0628aae2213d66d4a"]
}

variable "lb_enable_deletion_protection" {
  description = "enable_deletion_protection true or false"
  type        = bool
  default     = false
}


variable "lb_target_port" {
  description = "lb_target_port 80 or 443"
  type        = number
  default     = 80
}

variable "lb_protocol" {
  description = "lb_protocol HTTP (ALB) or TCP (NLB)"
  type        = string
  default     = "HTTP"
}

variable "lb_target_type" {
  description = "Target type ip (ALB/NLB), instance (Autosaling group)"
  type        = string
  default     = "instance"
}

variable "lb_vpc_id" {
  description = "vpc_id"
  type        = string
  default     = null
}

variable "lb_listener_port" {
  description = "lb_listener_port"
  type        = number
  default     = 80
}

variable "lb_listener_protocol" {
  description = "lb_listener_protocol HTTP, TCP, TLS"
  type        = string
  default     = "HTTP"
}



variable "lb_target_tags_map" {
  description = "Tag map for the LB target resources"
  type        = map(string)
  default     = {}
}

# -------------------------------------------
# Auto scalling
# -------------------------------------------

variable "as_name" {
  description = "AS name"
  type        = string
  default     = "Myas"
}

variable "max_size"{
        default = "1"
}
variable "min_size"{
        default = "1"
}
variable "desired_capacity"{
        default = "1"
}
variable "asg_health_check_type"{
        default = "ELB"
}
variable "target_group_arns"{
        default = []
}


