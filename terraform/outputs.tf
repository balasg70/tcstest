output "id" {
  value       = aws_vpc.default.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "List of public subnet IDs"
}


output "security_group_id" {
  value       = aws_security_group.default.id
  description = "Security group ID tied to bastion instance"
}

output "cidr_block" {
  value       = var.cidr_block
  description = "The CIDR block associated with the VPC"
}

output "test-bucket" {
  value       = var.test_results_bucket_name
  description = "Test results bucket name"
}