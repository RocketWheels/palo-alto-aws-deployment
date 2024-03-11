resource "aws_instance" "palo_alto_firewall" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id 
  key_name      = var.key_name
  count = var.firewall_count
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.palo_alto_profile[count.index].name
  user_data = <<-EOF
              vmseries-bootstrap-aws-s3bucket=${var.s3_bucket_name}
              EOF
#  depends_on             = var.depends_on
  tags = var.tags
}

resource "aws_network_interface" "secondary" {
  subnet_id       = var.subnet_id
  security_groups = var.security_group_ids
  description = "Secondary network interface for Palo Alto Firewall"
}

#################Interfaces caused error when increasing Firewall count from 1 to 2
# resource "aws_network_interface_attachment" "secondary_attachment" {
#   count = var.firewall_count
#   instance_id          = aws_instance.palo_alto_firewall[count.index].id
#   network_interface_id = aws_network_interface.secondary.id
#   device_index         = 1
# }

# resource "aws_network_interface" "third" {
#   subnet_id       = var.subnet_id
#   security_groups = var.security_group_ids
#   description = "Third network interface for Palo Alto Firewall"
# }

# resource "aws_network_interface_attachment" "third_attachment" {
#   count = var.firewall_count
#   instance_id          = aws_instance.palo_alto_firewall[count.index].id
#   network_interface_id = aws_network_interface.third.id
#   device_index         = 2
# }

output "s3_bucket_name" {
  value = var.s3_bucket_name
}

resource "aws_iam_role" "palo_alto_s3_access" {
  count = var.firewall_count
  name = "palo_alto_s3_access-${count.index}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
    }]
  })
}


resource "aws_iam_policy" "s3_read_policy" {
  count = var.firewall_count
  name   = "S3ReadPolicyForPaloAlto-${count.index}"
  policy = jsonencode({
   "Version": "2012-10-17", 
   "Statement": [ 
   { 
      "Effect": "Allow", 
      "Action": ["s3:ListBucket"], 
      "Resource": ["${var.s3_bucket_arn}"] 
   }, 
   { 
      "Effect": "Allow", 
      "Action": ["s3:GetObject"], 
      "Resource": ["${var.s3_bucket_arn}/*"] 
      } 
   ] 
} )
}

resource "aws_iam_role_policy_attachment" "s3_read_policy_attach" {
  count = var.firewall_count
  role       = aws_iam_role.palo_alto_s3_access[count.index].name
  policy_arn = aws_iam_policy.s3_read_policy[count.index].arn
}

resource "aws_iam_instance_profile" "palo_alto_profile" {
  count = var.firewall_count
  role = aws_iam_role.palo_alto_s3_access[count.index].id
}