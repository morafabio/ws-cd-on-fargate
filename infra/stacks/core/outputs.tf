output "org-name" {
  value = local.org-name
}

output "aws_ecs_cluster-main-id" {
  value = aws_ecs_cluster.main.id
}

output "aws_subnet-public_id" {
  value = aws_subnet.public.id
}

output "aws_security_group-alb_sg-id" {
  value = aws_security_group.alb_sg.id
}

output "aws_vpc-main-id" {
  value = aws_vpc.main.id
}

output "aws_lb-app_lb-arn" {
  value = local.enable_alb && length(aws_lb.app_lb) > 0 ? aws_lb.app_lb[0].arn : null
}