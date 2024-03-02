# output "public_ip" {
#   value = aws_instance.example.public_ip
#   description = "The public IP address of the EC2 instance"
# }

# output "firewall_public_ip" {
#   value = aws_instance.palo_alto_firewall.public_ip
# }

output "public_ip_firewalls" {
  value = module.palo_alto_firewall.public_ip
}
# output "public_ip_panorama" {
#   value = module.palo_alto_panorama.public_ip
# }

output "bucket_name" {
  value = aws_s3_bucket.bootstrap_bucket.id
}
output "bucket" {
  value = aws_s3_bucket.bootstrap_bucket.bucket
}
