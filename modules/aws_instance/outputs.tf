output "instance_id" {
  # value = aws_instance.palo_alto_firewall.id
  value = [for instance in aws_instance.palo_alto_firewall : instance.id]
}

#Output was used before aws instance was moved to module
output "public_ip" {
  # value = aws_instance.palo_alto_firewall.public_ip
  value = [for instance in aws_instance.palo_alto_firewall : instance.public_ip]
}


