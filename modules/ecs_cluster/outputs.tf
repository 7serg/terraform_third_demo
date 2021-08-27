/*
output "s3_bucket_id" {
  value = aws_s3_bucket.demoecs_bucket.id
}
*/
/*
output "s3_bucket_region" {
  value = aws_s3_bucket.demoecs_bucket.region
}
*/

output "vpc_id" {
  value = aws_vpc.demoecs_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.demoecs_vpc.cidr_block
}


output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}


output "public_route_table_id" {
  value = aws_route_table.public_subnets.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}


output "eip_for_nat" {
  value = aws_eip.elastic_ip_for_nat[*].id
}

output "aws_nat_gateway_ids" {
  value = aws_nat_gateway.for_private_subnets[*].id
}



output "private_route_table_id" {
  value = aws_route_table.private[*].id
}

output "security_group_alb_id" {
  value = aws_security_group.alb.id
}

output "sg_bastion_id" {
  value = aws_security_group.bastion.id
}

output "sg_webserver_id" {
  value = aws_security_group.webserver.id
}

output "web_server_ids" {
  value = aws_instance.web_server[*].id
}


output "aws_lb_id" {
  value = aws_lb.ecs_cluster_alb.id
}

output "aws_lb_dns" {
  value = aws_lb.ecs_cluster_alb.dns_name
}

output "aws_lb_target_group_id" {
  value = aws_lb_target_group.ecs_cluster_alb.id
}

output "aws_lb_listener_id" {
  value = aws_lb_listener.ecs_cluster_alb.id
}

output "aws_lb_listener_arn" {
  value = aws_lb_listener.ecs_cluster_alb.arn
}



output "aws_ecs_cluster_id" {
  value = aws_ecs_cluster.app_cluster.id
}


output "ecs_cluster_iam_role_id" {
  value = aws_iam_role.ecs_cluster_role.id
}

output "ecs_cluster_iam_role_arn" {
  value = aws_iam_role.ecs_cluster_role.arn
}

output "aws_iam_role_policy_for_ecs_cluster_id" {
  value = aws_iam_role_policy.ecs_cluster_policy.id
}

output "fargate_iam_role_id" {
  value = aws_iam_role.fargate_iam_role.id
}

output "fargate_iam_role_arn" {
  value = aws_iam_role.fargate_iam_role.arn
}

output "fargate_iam_role_policy_id" {
  value = aws_iam_role_policy.fargate_iam_role_policy.id
}


output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
}
