aws ec2 describe-vpcs --filters "Name=vpc-id,Values=$vpc_id" --query 'Vpcs[*].[Tags][*][*]'
aws ec2 describe-subnets --filters "Name=subnet-id,Values=$public_subnet_a_id" --query 'Subnets[*].[Tags][*][*][0].Value'
aws ec2 describe-subnets --filters "Name=subnet-id,Values=$public_subnet_c_id" --query 'Subnets[*].[Tags][*][*][0].Value'
aws ec2 describe-subnets --filters "Name=subnet-id,Values=$private_subnet_a_id" --query 'Subnets[*].[Tags][*][*][0].Value'
aws ec2 describe-subnets --filters "Name=subnet-id,Values=$private_subnet_c_id" --query 'Subnets[*].[Tags][*][*][0].Value'
aws ec2 describe-internet-gateways --filters "Name=internet-gateway-id,Values=$igw_id"  --query 'InternetGateways[*].[Tags][*][*][0].Value'
aws ec2 describe-nat-gateways --filter "Name=nat-gateway-id,Values=$nat_id" --query 'NatGateways[*].[Tags][*][*][0].Value'
aws ec2 describe-route-tables --filters "Name=route-table-id,Values=$route_table_public_id" --query 'RouteTables[*].[Tags][*][*][0].Value'
aws ec2 describe-route-tables --filters "Name=route-table-id,Values=$route_table_private_id" --query 'RouteTables[*].[Tags][*][*][0].Value'
aws ec2 describe-security-groups --filters "Name=group-id,Values=$security_group_public_id" --query 'SecurityGroups[*].[Tags][*][*][0].Value'
aws ec2 describe-security-groups --filters "Name=group-id,Values=$security_group_private_id" --query 'SecurityGroups[*].[Tags][*][*][0].Value'
