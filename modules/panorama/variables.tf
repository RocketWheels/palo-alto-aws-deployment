variable "ami_id" {
  description = "AMI ID for the AWS instance"
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

# variable "depends_on" {
#   description = "Resources that this AWS instance depends on"
# }

variable "tags" {
  description = "Tags for the AWS instance"
}
