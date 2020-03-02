# 보안 그룹
resource "aws_security_group" "CRBS2-security_group-public" {
  name        = "CRBS2-public"
  description = "security_group for public"
  vpc_id = "${aws_vpc.CRBS2-vpc.id}"

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = "-1"
    to_port    = "-1"
    description = "for ping test"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = "-1"
    to_port    = "-1"
    description = "for ping test"
  }

  tags = {
    Name = "CRBS2-public"
  }
}

resource "aws_security_group" "CRBS2-security_group-private" {
  name        = "CRBS2-private"
  description = "security_group for private"

  vpc_id = "${aws_vpc.CRBS2-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.1.0/24"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.2.0/24"]
  }
  ingress {
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = "-1"
    to_port    = "-1"
    description = "for ping test"
  }


  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = "-1"
    to_port    = "-1"
    description = "for ping test"
  }

  tags = {
    Name = "CRBS2-private"
  }
}

resource "aws_security_group_rule" "public-egress-MySQL" {
  type            = "egress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS2-security_group-private.id
  security_group_id = aws_security_group.CRBS2-security_group-public.id
}
resource "aws_security_group_rule" "private-ingress-HTTP" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS2-security_group-public.id
  security_group_id = aws_security_group.CRBS2-security_group-private.id
}
resource "aws_security_group_rule" "private-ingress-MySQL" {
  type            = "ingress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS2-security_group-public.id
  security_group_id = aws_security_group.CRBS2-security_group-private.id
}
resource "aws_security_group_rule" "private-ingress-HTTPS" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS2-security_group-public.id
  security_group_id = aws_security_group.CRBS2-security_group-private.id
}
resource "aws_security_group_rule" "private-egress-MySQL" {
  type            = "egress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS2-security_group-public.id
  security_group_id = aws_security_group.CRBS2-security_group-private.id
}
