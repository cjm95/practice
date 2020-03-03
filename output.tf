output "vpc_id" {
  value="${aws_vpc.CRBS2-vpc.id}"
}
output "public_subnet_a_id" {
  value="${aws_subnet.CRBS2-subnet-public-a.id}"
}
output "public_subnet_c_id" {
  value="${aws_subnet.CRBS2-subnet-public-c.id}"
}
output "private_subnet_a_id" {
  value="${aws_subnet.CRBS2-subnet-private-a.id}"
}
output "private_subnet_c_id" {
  value="${aws_subnet.CRBS2-subnet-private-c.id}"
}
output "igw_id" {
  value="${aws_internet_gateway.CRBS2-igw.id}"
}
output "nat_id" {
  value="${aws_nat_gateway.CRBS2-nat.id}"
}
output "route_table_public_id" {
  value="${aws_route_table.CRBS2-route_table-public.id}"
}
output "route_table_private_id" {
  value="${aws_route_table.CRBS2-route_table-private.id}"
}
output "security_group_public_id" {
  value="${aws_security_group.CRBS2-security_group-public.id}"
}
output "security_group_private_id" {
  value="${aws_security_group.CRBS2-security_group-private.id}"
}
