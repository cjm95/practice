// 프로 바이더 설정 
// 테라폼과 외부 서비스를 연결해주는 기능
provider "aws" {
    profile ="aws_provider"
    region = var.my_region
    # access_key =var.aws_access_key
    # secret_key = var.aws_secret_key
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
