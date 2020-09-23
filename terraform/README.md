# terraform-aws-vpc



A Terraform module to create an Amazon Web Services (AWS) Virtual Private Cloud (VPC).

## Usage

This module creates a VPC alongside a variety of related resources, including:

- Public subnets
- Public route tables
- Elastic IPs
- An Internet Gateway
- A EC2 instance

Example usage:

```hcl
module "vpc" {
  source = "https://github.com/balasg70/tcstest/tree/master/terraform"

  name = "Default"
  region = "us-east-1"
  key_name = "hector"
  cidr_block = "10.0.0.0/16"
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  _ami = "ami-6869aa05"
  ec2_ebs_optimized = true
  ec2_instance_type = "t3.micro"

  project = "Something"
  environment = "Staging"
}
```

### Configuring security rules

By default, this module adds no security rules to the EC2 instance, meaning
that all traffic will be blocked.

In order to configure security rules for the bastion, use the
`bastion_security_group_id` output. For example:

```hcl
resource "aws_security_group_rule" "ssh_ingress" {
  security_group_id = module.vpc.ec2_security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.bastion_inbound_cidr_block]
}
```



## Variables

- `name` - Name of the VPC (default: `Default`)
- `project` - Name of project this VPC is meant to house (default: `Unknown`)
- `environment` - Name of environment this VPC is targeting (default: `Unknown`)
- `region` - Region of the VPC (default: `us-east-1`)
- `key_name` - EC2 Key pair name for the bastion
- `cidr_block` - CIDR block for the VPC (default: `10.0.0.0/16`)
- `public_subnet_cidr_blocks` - List of public subnet CIDR blocks (default: `["10.0.0.0/24","10.0.2.0/24"]`)
- `availability_zones` - List of availability zones (default: `["us-east-1a", "us-east-1b"]`)
- `_ami` - EC2 Amazon Machine Image (AMI) ID
- `ec2_ebs_optimized` - If true, the bastion instance will be EBS-optimized (default: `false`)
- `ec2_instance_type` - Instance type for bastion instance (default: `t3.nano`)
- `tags` - Extra tags to attach to the VPC resources (default: `{}`)

## Outputs

- `id` - VPC ID
- `public_subnet_ids` - List of public subnet IDs
- `ec2_hostname` - Public DNS name for bastion instance
- `ec2_security_group_id` - Security group ID tied to bastion instance
- `cidr_block` - The CIDR block associated with the VPC

