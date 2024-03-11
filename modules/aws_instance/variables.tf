variable "ami_id" {
  description = "AMI ID for the AWS instance"
}

variable "firewall_count" {
  description = "amount of firewalls desired"
}

variable "instance_type" {
  description = "Instance type for the AWS instance"
}

variable "subnet_id" {
  description = "Subnet ID for the AWS instance"
}

variable "key_name" {
  description = "Name of the SSH key pair"
}

variable "security_group_ids" {
  description = "List of security group IDs"
}


variable "tags" {
  description = "Tags for the AWS instance"
}

variable "aws_s3_bucket" {
  description = "Instance type for the AWS instance"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket containing the bootstrap file"
  type        = string
}


variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket where the bootstrap file is stored"
  type        = string
}

