resource "aws_instance" "palo_alto_panorama" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = var.security_group_ids
#  depends_on             = var.depends_on

  tags = var.tags
}