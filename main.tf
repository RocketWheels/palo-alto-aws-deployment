
# Define a resource block for an AWS Key Pair, which will be used to authenticate SSH access to EC2 instances.
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = data.vault_generic_secret.my_secrets.data["value"]
}

module "palo_alto_firewall" {
  source = "./modules/aws_instance"
  firewall_count = var.firewall_count
  ami_id           = "ami-03810899027cb545e"
  instance_type    = "c5n.xlarge"
  subnet_id        = aws_subnet.main.id
  key_name         = aws_key_pair.deployer.key_name
  security_group_ids = [aws_security_group.firewall.id]
  depends_on       = [aws_security_group.firewall]
  tags = {
    Name = "PaloAltoFirewall"
  }
  aws_s3_bucket = aws_s3_bucket.bootstrap_bucket.bucket
  s3_bucket_name = aws_s3_bucket.bootstrap_bucket.id
  s3_bucket_arn = aws_s3_bucket.bootstrap_bucket.arn
}

#Deploy Panorama appliance module
# module "palo_alto_panorama" {
#   source = "./modules/panorama"

#   ami_id           = "ami-010d13b4b3d4aa49d" #panorama 11.1.0
#   instance_type    = "c5.4xlarge"
#   subnet_id        = aws_subnet.main.id
#   key_name         = aws_key_pair.deployer.key_name
#   security_group_ids = [aws_security_group.firewall.id]
#   depends_on       = [aws_security_group.firewall]
#   tags = {
#     Name = "PaloAltoPanorama"
#   }
# }
