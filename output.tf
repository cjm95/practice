output "vpc-id" {
  value="${aws_vpc.CRBS2-vpc.id}"
}
output "public-subnet-a-id" {
  value="${aws_subnet.CRBS2-subnet-public-a.id}"
}
output "public-subnet-c-id" {
  value="${aws_subnet.CRBS2-subnet-public-c.id}"
}
output "private-subnet-a-id" {
  value="${aws_subnet.CRBS2-subnet-private-a.id}"
}
output "private-subnet-c-id" {
  value="${aws_subnet.CRBS2-subnet-private-c.id}"
}
output "igw-id" {
  value="${aws_internet_gateway.CRBS2-igw.id}"
}
output "nat-id" {
  value="${aws_nat_gateway.CRBS2-nat.id}"
}
output "route-table-public-id" {
  value="${aws_route_table.CRBS2-route_table-public.id}"
}
output "route-table-private-id" {
  value="${aws_route_table.CRBS2-route_table-private.id}"
}
output "security-group-public-id" {
  value="${aws_security_group.CRBS2-security_group-public.id}"
}
output "security-group-private-id" {
  value="${aws_security_group.CRBS2-security_group-private.id}"
}
