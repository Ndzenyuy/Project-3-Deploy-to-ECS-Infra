resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "text"
        x    = 0
        y    = 0
        width = 24
        height = 1
        properties = {
          markdown = "# ECS Cluster Monitoring - ${var.cluster_name}"
        }
      },
      {
        type = "metric"
        x    = 0
        y    = 1
        width = 8
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.cluster_name, "ServiceName", var.service_name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "ECS CPU Utilization"
          period  = 300
        }
      },
      {
        type = "metric"
        x    = 8
        y    = 1
        width = 8
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.cluster_name, "ServiceName", var.service_name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "ECS Memory Utilization"
          period  = 300
        }
      },
      {
        type = "metric"
        x    = 0
        y    = 7
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix],
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "ALB Performance"
          period  = 300
        }
      },
      {
        type = "metric"
        x    = 12
        y    = 7
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix],
            ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Target Health"
          period  = 300
        }
      },
      {
        type = "text"
        x    = 0
        y    = 13
        width = 24
        height = 1
        properties = {
          markdown = "# RDS Database Metrics"
        }
      },
      {
        type = "metric"
        x    = 0
        y    = 14
        width = 8
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "RDS CPU Utilization"
          period  = 300
        }
      },
      {
        type = "metric"
        x    = 8
        y    = 14
        width = 8
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.db_instance_id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Database Connections"
          period  = 300
        }
      },
      {
        type = "metric"
        x    = 16
        y    = 14
        width = 8
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.db_instance_id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Free Storage Space"
          period  = 300
        }
      },
      {
        type = "metric"
        x    = 0
        y    = 20
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", var.db_instance_id],
            ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", var.db_instance_id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Database Latency"
          period  = 300
        }
      },
      {
        type = "metric"
        x    = 12
        y    = 20
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", var.db_instance_id]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Freeable Memory"
          period  = 300
        }
      }
    ]
  })
}
