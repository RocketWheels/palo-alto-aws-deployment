output "instance_id" {
  value = aws_instance.palo_alto_firewall.id
}

#Output was used before aws instance was moved to module
output "public_ip" {
  value = aws_instance.palo_alto_firewall.public_ip
}


