resources "aws_vpc" "myvpc" {
  cidr_block ="10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_home = true

   tags = {
    Name = "Myvpc1"
}
}
resource "aws_subnet" "public_subnet" {
vpc_id = "Myvpc1"
cidr_block ="10.0.0.0/24"
map_public_ip_on_launch = true

   tags = {
    Name = "Public1"
  }
 }
 resources "aws_subnet" "private_subnet" {
 vpc_id = "Myvpc1"
 cidr_block = "10.0.0.0/24"

   tags = {
    Name = "Private1"
  }

resources "aws_security_group" "MySG" {
  name = "My_SG"
  description = "SSH inbound traffic"
  vpc_id = aws_vpc.Myvpc1.id
 }
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "10.0.0.0/16"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = 10.0.0.0/24
  }
}

