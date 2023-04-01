variable "aws_region" {
  description = "The AWS region to use to create resources."
  default     = "ap-south-1"
}

variable "bucket_prefix" {
    type        = string
    description = "(required since we are not using 'bucket') Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
    default     = "my-s3bucket-"
}

variable "tags" {
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

# Load Balancer

variable "lb_protocol" {
        description = "lb_protocol HTTP (ALB) or TCP (NLB)"
        type        = string
        default     = "HTTP"
}

variable "lb_listener_protocol" {
        description = "lb_listener_protocol HTTP, TCP, TLS"
        type        = string
        default     = "HTTP"
}

variable "lb_enable_deletion_protection" {
        description = "enable_deletion_protection true or false"
        type        = bool
        default     = false
}

variable "vpc_cidr" {
        type= string
        default= "10.0.0.0/16"
}

variable "vpc_name"{
        type= string
        default= "terra-vpc1"
}

variable "lb_name"{
        type= string
        default = "terra-lb"
}

variable "lb_internal"{
        type= bool
        default= "false"
}


variable "lb_load_balancer_type"{
        type= string
        default= "application"
}

variable "lb_subnets"{
        type= list(string)
        default = ["subnet-08efb067b0c124552","subnet-0628aae2213d66d4a"]
}
variable "lb_vpc_id" {
        description = "vpc_id"
        type        = string
        default     = null
}


variable "lb_target_type"{
        type= string
        default = "instance"
}

variable "lb_target_port"{
        type = number
        default = "80"
}

variable "lb_listener_port" {
        description = "lb_listener_port"variable "lb_tags" {
        description = "Tag map for the resource"
        type        = map(string)
        default     = {}
}

variable "lb_target_tags_map" {
        description = "Tag map for the LB target resources"
        type        = map(string)
        default     = {}
}

variable "lb_tags" {
        description = "Tag map for the resource"
        type        = map(string)
        default     = {}
}

# Auto Scalling

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

                                                                                                                                                                  145,0-1       Bot


 
