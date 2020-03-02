// 프로 바이더 설정 
// 테라폼과 외부 서비스를 연결해주는 기능
provider "aws" {
    profile ="aws_provider"
    region = var.my_region
    access_key =var.aws_access_key
    secret_key = var.aws_secret_key
}
// VPC 가상 네트워크 설정
resource "aws_vpc" "CRBS2-vpc" {
  cidr_block="172.16.0.0/16"  
  enable_dns_hostnames="true"  //dns 호스트 네임 활성화
  enable_dns_support   = true
  instance_tenancy     = "default"  
  tags = {
      Name="CRBS2-vpc"
      }  //태그 달아줌

}
// 서브넷 설정
# 다음과 같이 2개의 AZ에 public, private subnet을 각각 1개씩 생성한다.
# ${aws_vpc.dev.id} 는 aws_vpc의 dev리소스로부터 id값을 가져와서 세팅한다.
# resource name은 {aws_subnet.public_1a.id} 와 같이 작성하기 쉽도록 underscore를 사용했다.
resource "aws_subnet" "CRBS2-subnet-public-a" {
  vpc_id                    = "${aws_vpc.CRBS2-vpc.id}"
  availability_zone         = var.my_az1
  cidr_block                = "172.16.1.0/24"
  map_public_ip_on_launch   = true

  tags = {
    Name = "CRBS2-public-a"
  }
}

resource "aws_subnet" "CRBS2-subnet-private-a" {
  vpc_id            = "${aws_vpc.CRBS2-vpc.id}"
  availability_zone = var.my_az1
  cidr_block        = "172.16.3.0/24"
  map_public_ip_on_launch   = false

  tags = {
    Name = "CRBS2-private-a"
  }
}

resource "aws_subnet" "CRBS2-subnet-public-c" {
  vpc_id            = "${aws_vpc.CRBS2-vpc.id}"
  availability_zone = var.my_az2
  cidr_block        = "172.16.2.0/24"
  map_public_ip_on_launch   = true

  tags = {
    Name = "CRBS2-public-c"
  }
}

resource "aws_subnet" "CRBS2-subnet-private-c" {
  vpc_id            = "${aws_vpc.CRBS2-vpc.id}"
  availability_zone = var.my_az2
  cidr_block        = "172.16.4.0/24"
  map_public_ip_on_launch   = false

  tags = {
    Name = "CRBS2-private-c"
  }
}
# dev VPC에서 사용할 IGW를 정의한다. 
# IGW는 AZ에 무관하게 한개의 IGW를 공유해서 사용할 수 있다.
resource "aws_internet_gateway" "CRBS2-igw" {
  vpc_id = "${aws_vpc.CRBS2-vpc.id}"

  tags = {
    Name = "CRBS2-igw"
  }
}
# 각각의 AZ의 NAT에서 사용할 EIP를 정의한다.
# vpc = true 항목은 EIP 생성 시 EIP의 scope를 VPC로 할지 classic으로 할지 물어봤던 옵션을 의미하는 것으로 추측된다.
resource "aws_eip" "CRBS2-eip" {
  vpc = true
  tags = {
    Name = "CRBS2-eip"
  }
}


# NAT Gateway
resource "aws_nat_gateway" "CRBS2-nat" {
  allocation_id = "${aws_eip.CRBS2-eip.id}"
  subnet_id     = "${aws_subnet.CRBS2-subnet-public-a.id}"
  tags={Name="CRBS2-nat"}
}

# NAT도 IGW처럼 한개를 공유해서 사용하는지, 아니면 AZ별로 각각 NAT를 생성해야 하나 의문이 생겼었는데 
# NAT 게이트웨이 – Amazon Virtual Private Cloud 가이드 문서에 따르면
# 가용영역(AZ) 별로 NAT 게이트웨이를 사용해야 복수의 AZ를 사용하는 장점을 같이 가져갈 수 있음을 알 수 있다.
# dev_public
resource "aws_route_table" "CRBS2-route_table-public" {
  vpc_id = "${aws_vpc.CRBS2-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.CRBS2-igw.id}"
  }

  tags = {
    Name = "CRBS2-public"
  }
}

resource "aws_route_table_association" "CRBS2-route_table_associationpublic-a" {
  subnet_id      = "${aws_subnet.CRBS2-subnet-public-a.id}"
  route_table_id = "${aws_route_table.CRBS2-route_table-public.id}"
}

resource "aws_route_table_association" "CRBS2-route_table_associationpublic-c" {
  subnet_id      = "${aws_subnet.CRBS2-subnet-public-c.id}"
  route_table_id = "${aws_route_table.CRBS2-route_table-public.id}"
}


resource "aws_route_table" "CRBS2-route_table-private" {
  vpc_id = "${aws_vpc.CRBS2-vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.CRBS2-nat.id}"
  }

  tags = {
    Name = "CRBS2-private"
  }
}

resource "aws_route_table_association" "CRBS2-route_table_association-private-a" {
  subnet_id      = "${aws_subnet.CRBS2-subnet-private-a.id}"
  route_table_id = "${aws_route_table.CRBS2-route_table-private.id}"
}
resource "aws_route_table_association" "CRBS2-route_table_association-private-c" {
  subnet_id      = "${aws_subnet.CRBS2-subnet-private-c.id}"
  route_table_id = "${aws_route_table.CRBS2-route_table-private.id}"
}


# resource "aws_route_table" "CRBS2-private-c" {
#   vpc_id = "${aws_vpc.CRBS2-vpc.id}"

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = "${aws_nat_gateway.CRBS2-nat-c.id}"
#   }

#   tags = {
#     Name = "CRBS2-nat-c"
#   }
# }

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

# ====================================================create server===================================================

resource "aws_instance" "crbs-bastion" {
  ami                         = "${var.bastion-ami}"
  availability_zone           = var.my_az1
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.CRBS2-security_group-public.id}"]
  subnet_id                   = "${aws_subnet.CRBS2-subnet-public-a.id}"
  associate_public_ip_address = true

  tags = {
    Name = "Bastion"
  }
}

# CRBS2-public UI 인스턴스 설정
resource "aws_instance" "CRBS2-public-a" {
  instance_type               = "t2.micro"
  ami                         = var.ui_ami_id-a
  key_name                    = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.CRBS2-security_group-public.id}"]
  subnet_id                   = aws_subnet.CRBS2-subnet-public-a.id
  associate_public_ip_address = true

  tags={
    Name="CRBS2-public-a"
    }
}
resource "aws_instance" "CRBS2-public-c" {
  instance_type             = "t2.micro"
    ami                     = var.ui_ami_id-c
    key_name                = var.key_name
    vpc_security_group_ids  = ["${aws_security_group.CRBS2-security_group-public.id}"]
    subnet_id               = aws_subnet.CRBS2-subnet-public-c.id
    associate_public_ip_address = true

    tags = { 
      Name = "CRBS2-public-c"  
    }
}

# CRBS2-public API 인스턴스 설정
resource "aws_instance" "CRBS2-private-a" {
  instance_type               = "t2.micro"
  ami                         = var.api_ami_id-a
  key_name                    = var.key_name
  vpc_security_group_ids      = ["${aws_security_group.CRBS2-security_group-private.id}"]
  subnet_id                   = aws_subnet.CRBS2-subnet-private-a.id

  tags={
    Name="CRBS2-private-a"
    }
}
resource "aws_instance" "CRBS2-private-c" {
  instance_type             = "t2.micro"
    ami                     = var.api_ami_id-c
    key_name                = var.key_name
    vpc_security_group_ids  = ["${aws_security_group.CRBS2-security_group-private.id}"]
    subnet_id               = aws_subnet.CRBS2-subnet-private-c.id

    tags = { 
      Name = "CRBS2-private-c"  
    }
}


# External alb 설정
resource "aws_lb" "CRBS2-external" {
  name            = "CRBS2-external"
  internal        = false
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [aws_security_group.CRBS2-security_group-public.id]
  subnets = [aws_subnet.CRBS2-subnet-public-a.id, aws_subnet.CRBS2-subnet-public-c.id]
  enable_deletion_protection = false

  tags = {
    Name = "CRBS2-external"
  }
}

# External alb target group 설정
resource "aws_lb_target_group" "CRBS2-UI" {
  name     = "CRBS2-UI"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.CRBS2-vpc.id
  target_type = "instance"
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_path
    interval            = 10
    port                = 80
  }
  tags = {Name   = "CRBS2-UI" }
}

# External listener
resource "aws_lb_listener" "CRBS2-UI-listener" {
  load_balancer_arn = "${aws_lb.CRBS2-external.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.CRBS2-UI.arn}"
  }
}

# alb에 UI instance 연결
resource "aws_alb_target_group_attachment" "CRBS2-UI-a" {
  target_group_arn = aws_lb_target_group.CRBS2-UI.arn
  target_id        = aws_instance.CRBS2-public-a.id
  port             = 80
}
resource "aws_alb_target_group_attachment" "CRBS2-UI-c" {
  target_group_arn = aws_lb_target_group.CRBS2-UI.arn
  target_id        = aws_instance.CRBS2-public-c.id
  port             = 80
}

# ========================================================

# Internal alb 설정
resource "aws_lb" "CRBS2-internal" {
  name            = "CRBS2-internal"
  internal        = true
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [aws_security_group.CRBS2-security_group-public.id]
  subnets = [aws_subnet.CRBS2-subnet-private-a.id, aws_subnet.CRBS2-subnet-private-c.id]
  enable_deletion_protection = false

  tags = {
    Name = "CRBS2-internal"
  }
}

# Internal alb target group 설정
resource "aws_lb_target_group" "CRBS2-API" {
  name     = "CRBS2-API"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.CRBS2-vpc.id
  target_type = "instance"
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_path
    interval            = 10
    port                = 80
  }
  tags = {Name   = "CRBS2-API" }
}

# Internal listener
resource "aws_lb_listener" "CRBS2-API-listener" {
  load_balancer_arn = "${aws_lb.CRBS2-internal.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.CRBS2-API.arn}"
  }
}

# Internal alb에 API instance 연결
resource "aws_alb_target_group_attachment" "CRBS2-API-a" {
  target_group_arn = aws_lb_target_group.CRBS2-API.arn
  target_id        = aws_instance.CRBS2-private-a.id
  port             = 80
}
resource "aws_alb_target_group_attachment" "CRBS2-API-c" {
  target_group_arn = aws_lb_target_group.CRBS2-API.arn
  target_id        = aws_instance.CRBS2-private-c.id
  port             = 80
}


# ==============================autoscaling================================= #

# aws_launch_template
# resource "aws_launch_template" "nginx-template" {
#   name = "Nginx-template"

#   image_id = "${var.amazon_linux}"

#   instance_type = "t2.micro"

#   key_name = var.key_name

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups = ["${aws_security_group.public-sg.id}"]
#   }

#   tag_specifications {
#     resource_type = "instance"

#   tags = {
#       Name = "Nginx-template"
#     }
#   }
# }

# autoscaling group

# resource "aws_autoscaling_group" "nginx-asg" {
#   name               = "nginx-asg"
#   availability_zones = ["ap-northeast-2a","ap-northeast-2c"]
#   desired_capacity   = 2
#   max_size           = 6
#   min_size           = 2
#   health_check_type         = "ELB"
#   health_check_grace_period = 300
#   vpc_zone_identifier       = ["${aws_subnet.public_1c.id}", "${aws_subnet.public_1a.id}"]
#   termination_policies      = ["default"]
#   target_group_arns  = ["${aws_lb_target_group.SRE_web.arn}"]
#   launch_template {
#     id      = "${aws_launch_template.nginx-template.id}"
#     version = "$Latest"

#   }
#   tag {
#     key                 = "Name"
#     value               = "nginx-asg"
#     propagate_at_launch = true
#   }
# }
# resource "aws_autoscaling_policy" "nginx-asg-policy" {
#   name                   = "nginx-asg-policy"
#   scaling_adjustment     = 80
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = "${aws_autoscaling_group.nginx-asg.name}"
# }

# # Create a new ALB Target Group attachment
# resource "aws_autoscaling_attachment" "asg_attachment_bar" {
#   autoscaling_group_name = "${aws_autoscaling_group.nginx-asg.id}"
#   alb_target_group_arn   = "${aws_lb_target_group.SRE_web.arn}"
# }

# ====================================================create RDS===================================================
resource "aws_db_subnet_group" "CRBS2-rds-subnet-group" {
  name       = "crbs-rds-subnet-group"
  subnet_ids = ["${aws_subnet.CRBS2-subnet-private-a.id}", "${aws_subnet.CRBS2-subnet-private-c.id}"]
  description = "RDS subnet group for CRBS"

  tags = {
    Name = "crbs-rds-subnet-group"
  }
}
resource "aws_db_instance" "CRBS2-rds-instance" {
  identifier           = "crbs-rds-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.CRBS2-rds-subnet-group.name
  multi_az             = true
  vpc_security_group_ids = ["${aws_security_group.CRBS2-security_group-private.id}"]
  # final_snapshot_identifier = "crbs-rds-instance"
  skip_final_snapshot = true
}