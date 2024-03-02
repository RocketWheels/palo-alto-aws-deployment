resource "aws_instance" "palo_alto_firewall" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id 
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.palo_alto_profile.name
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

resource "aws_network_interface_attachment" "secondary_attachment" {
  instance_id          = aws_instance.palo_alto_firewall.id
  network_interface_id = aws_network_interface.secondary.id
  device_index         = 1
}

resource "aws_network_interface" "third" {
  subnet_id       = var.subnet_id
  security_groups = var.security_group_ids
  description = "Third network interface for Palo Alto Firewall"
}

resource "aws_network_interface_attachment" "third_attachment" {
  instance_id          = aws_instance.palo_alto_firewall.id
  network_interface_id = aws_network_interface.third.id
  device_index         = 2
}

output "s3_bucket_name" {
  value = var.s3_bucket_name
}

resource "aws_iam_role" "palo_alto_s3_access" {
  name = "palo_alto_s3_access"

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
  name   = "S3ReadPolicyForPaloAlto"
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
  role       = aws_iam_role.palo_alto_s3_access.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

resource "aws_iam_instance_profile" "palo_alto_profile" {
  role = aws_iam_role.palo_alto_s3_access.name
}