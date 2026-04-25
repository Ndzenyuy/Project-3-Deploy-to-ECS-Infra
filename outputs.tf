output "vpc_id" {
  value = module.network.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name to access application"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_log_group" {
  description = "CloudWatch log group for ECS container logs"
  value       = module.ecs.log_group_name
}

output "db_endpoint" {
  description = "RDS endpoint for database connection"
  value       = module.rds.db_endpoint  
}




