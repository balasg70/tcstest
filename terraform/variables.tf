variable "name" {
  default     = "vpc_devops"
  type        = string
  description = "Name of the VPC"
}

variable "project" {
  type        = string
  description = "Name of project this VPC is meant to house"
}

variable "environment" {
  type        = string
  description = "Name of environment this VPC is targeting"
}

variable "region" {
  default     = "ap-southeast-1"
  type        = string
  description = "Region of the VPC"
}

variable "key_name" {
  type        = string
  description = "EC2 Key pair name for the bastion"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
  type        = list
  description = "List of availability zones"
}

variable "_ami" {
  type        = string
  description = "EC2 Amazon Machine Image (AMI) ID"
}

variable "ec2_ebs_optimized" {
  default     = false
  type        = bool
  description = "If true, the bastion instance will be EBS-optimized"
}

variable "ec2_instance_type" {
  default     = "t2.micro"
  type        = string
  description = "Instance type for Ec2 instance"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the VPC resources"
}


variable "bucket" {
}

variable "key" {
}

variable "workspace_key_prefix" {
}

# used for state locking
variable "dynamodb_table" {
}

variable "region" {
}

# Aws credentials profile
variable "profile" {
}

variable "external_ip_allow_list" {
}

#
# These vars come from an environment specific tfvars file under tfvars/
variable "aws_profile" {
}

variable "test_results_bucket_name" {
}



