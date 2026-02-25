output "cluster_name" {
  value = aws_ecs_cluster.ecs-cluster.name
}

output "service_name" {
  value = aws_ecs_service.client.name
}

output "cluster_id" {
  value = aws_ecs_cluster.ecs-cluster.id
}