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
