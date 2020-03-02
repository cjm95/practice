# acl
resource "aws_network_acl" "CRBS2-acl-public" {

  vpc_id = aws_vpc.CRBS2-vpc.id
  subnet_ids = [
    "${aws_subnet.CRBS2-subnet-public-a.id}",
    "${aws_subnet.CRBS2-subnet-public-c.id}"
  ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress { 
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }

  ingress { 
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress { 
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "-1"
    to_port    = "-1"
    icmp_type = -1
    icmp_code = -1
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "172.16.3.0/24"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 121
    action     = "allow"
    cidr_block = "172.16.4.0/24"
    from_port  = 22
    to_port    = 22
  }
  egress { 
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }
  egress { 
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768 
    to_port    = 65535
  }
  egress { 
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "172.16.3.0/24"
    from_port  = 3306 
    to_port    = 3306
  }
  egress { 
    protocol   = "tcp"
    rule_no    = 151
    action     = "allow"
    cidr_block = "172.16.4.0/24"
    from_port  = 3306 
    to_port    = 3306
  }
  egress {
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "-1"
    to_port    = "-1"
    icmp_type = -1
    icmp_code = -1
  }

  tags = {
    Name = "CRBS2-public"
  }
}

resource "aws_network_acl" "CRBS2-acl-private" {

  vpc_id = aws_vpc.CRBS2-vpc.id
  subnet_ids = [
    "${aws_subnet.CRBS2-subnet-private-a.id}",
    "${aws_subnet.CRBS2-subnet-private-c.id}"
  ]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 22
    to_port    = 22
  }
ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 3306
    to_port    = 3306
  }
  ingress { 
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 8080
    to_port    = 8080
  }

  ingress { 
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 1024
    to_port    = 65535
  }

  ingress { 
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "-1"
    to_port    = "-1"
    icmp_type = -1
    icmp_code = -1
    # description = "for ping test"
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  egress { 
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "172.16.1.0/24"
    from_port  = 1024 
    to_port    = 65535
  }
  egress { 
    protocol   = "tcp"
    rule_no    = 131
    action     = "allow"
    cidr_block = "172.16.2.0/24"
    from_port  = 1024 
    to_port    = 65535
  }
  egress { 
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080 
    to_port    = 8080
  }
  egress { 
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 3306 
    to_port    = 3306
  }
  egress {
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "-1"
    to_port    = "-1"
    icmp_type = -1
    icmp_code = -1
    # description = "for ping test"
  }

  tags = {
    Name = "CRBS2-private"
  }
}

