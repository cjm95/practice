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

