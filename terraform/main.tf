provider "aws" {
  version = "~> 3.0"
  alias   = "edge_provider"
  profile = var.aws_profile
  region  = "ap-southeast-1"
}

provider "aws" {
  access_key = ""
  secret_key = ""
  shared_credentials_file = "/Users/tf_user/.aws/creds"
  region     = "ap-southeast-1"
}

terraform {
  backend "s3" {
  }
}

resource "aws_s3_bucket" "test_results" {
  bucket = var.test_results_bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

#
# VPC resources
#
resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = var.name,
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = merge(
    {
      Name        = "gwInternet",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = merge(
    {
      Name        = "PublicRouteTable",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}



resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name        = "sub_public_devops",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


#
# EC2 instance resources
#
resource "aws_security_group" "default" {
  name  "allow_all"
  vpc_id = aws_vpc.default.id

  tags = merge(
    {
      Name        = "sg_devops",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All ssh traffic"
  security_group_id = [$"{aws_security_group.default.id}"]

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All http traffic"
  security_group_id = [$"{aws_security_group.default.id}"]


resource "aws_instance" "EC2" {
  ami                         = var._ami
  availability_zone           = var.availability_zones[0]
  ebs_optimized               = var.ec2_ebs_optimized
  instance_type               = var.ec2_instance_type
  key_name                    = "${aws_key_pair.generated_key.key_name}"
  monitoring                  = true
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true

  tags = merge(
    {
      Name        = "ec2_devops",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_eip" "default" {
  vpc = true

  instance                  = aws_instance.EC2.id
  associate_with_public_ip = "10.0.0.12"

tags = merge(
    { 
    Name = "eip_devops"
    Project     = var.project,
    Environment = var.environment
  },
var.tags
)
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.example.public_key_openssh}"
}



