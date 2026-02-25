resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.project_name}-Cluster"
}


#####Task definitions

resource "aws_ecs_task_definition" "lumia-task" {
  family                   = "lumiatech-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name      = "lumia-image"
    image     = var.image_uri
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    }],
    cpu    = var.container_cpu   
    memory = var.container_memory 
    # logConfiguration = {
    #   logDriver = "awslogs"
    #   options = {
    #     awslogs-group         = aws_cloudwatch_log_group.lumia.name
    #     awslogs-region        = var.region
    #     awslogs-stream-prefix = "ecs"
    #   }
    # }
  }])
}


#### Services


resource "aws_ecs_service" "client" {
  name            = "Lumiatech-ECS-Service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.lumia-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "lumia-image"
    container_port   = 8080
  }

  depends_on = [var.alb_listener_arn]
}
