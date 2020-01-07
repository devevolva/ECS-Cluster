###############################################################################
# 
# VARIABLES
#
###############################################################################

###############################################################################
# PROVIDER ####################################################################
variable "AWS_REGION" {
  default = "us-east-1"
}

###############################################################################
# VPC #########################################################################
variable "vpc_main_cidr_block" {
    description = "Main VPC CIDR block."
    default     = "192.168.0.0/16"
}

variable "secondary_cidr_blocks" {
    description = "Secondary CIDR blocks for AZ subnets."
    default     = ["192.168.0.0/20","192.168.16.0/20","192.168.32.0/20","192.168.48.0/20","192.168.64.0/20","192.168.80.0/20"]
}


###############################################################################
# SERVER ######################################################################
variable "aws_ECS_Opt_Linux_2" {
  description = "Amazon ECS-optimized Amazon Linux 2 AMI."
  default     = "ami-00afc256a955c31b5"
}

variable "aws_instance_type" {
  description = "AWS instance type."
  default     = "t2.micro"
}


###############################################################################
# DATASOURCES #################################################################
data "aws_availability_zones" "all" {}

data "aws_subnet_ids" "all_subnet_ids" {
    vpc_id = aws_vpc.main.id
}


###############################################################################
# R53 "A" RECORD ##############################################################
variable "r53_zone_id" {
    description = "Existing Route53 hosted zone id."
    default     = "Z32HEQVAQX766V"
}

variable "r53_domain_name" {
    description = "Domain name to be hosted by Route53."
    default     = "devevolvacloud.com"
}