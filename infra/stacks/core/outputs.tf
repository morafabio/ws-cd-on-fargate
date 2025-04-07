output "org_name" {
  value = local.org_name
}

output "aws_ecs_cluster_main_id" {
  value = aws_ecs_cluster.main.id
}

output "aws_subnet_public_ids" {
  value = aws_subnet.public[*].id
}

output "aws_security_group_alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "aws_lb_listener_lb_http_arn" {
  value = aws_lb_listener.lb_http.arn
}

output "aws_vpc_main_id" {
  value = aws_vpc.main.id
}

output "aws_lb_app_lb_arn" {
  value = local.enable_alb && length(aws_lb.app_lb) > 0 ? aws_lb.app_lb[0].arn : null
}

output "aws_lb_app_lb_dns_name" {
  value = local.enable_alb && length(aws_lb.app_lb) > 0 ? aws_lb.app_lb[0].dns_name : null
}