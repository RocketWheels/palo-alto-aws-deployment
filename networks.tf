# Palo Alto image VM-Series Next-Generation Firewall w/ Threat Prevention (PAYG)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true  # Enables auto-assigning public IP
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "firewall" {
  name        = "palo_alto_firewall"
  description = "Security group for Palo Alto firewall"
  vpc_id      = aws_vpc.main.id

  # Ingress rule to allow inbound HTTPS traffic from any IP
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Ingress rule to allow inbound ICMP (ping) traffic from any IP
  ingress {
    description = "Ping"
    from_port   = -1   # For ICMP, the from_port and to_port signify the ICMP type and code.
    to_port     = -1   # AWS uses -1 to allow all ICMP types and codes.
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Ingress rule to allow inbound SSH traffic from any IP
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  depends_on = [ aws_vpc.main ]
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}
# Create a route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}
# Associate the Internet Gateway with the Route Table
resource "aws_route" "internet_gateway_route" {
  route_table_id            = aws_route_table.main.id
  destination_cidr_block   = "0.0.0.0/0"
  gateway_id               = aws_internet_gateway.main.id
}

# Associate a route table with the subnet
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}