# CloudWatch Logging for ECS Containers

## Configuration Added

✅ **CloudWatch Log Group:** `/ecs/${project_name}`
✅ **Retention:** 7 days
✅ **Log Stream Prefix:** `ecs`

## Viewing Logs

### AWS Console
1. Go to CloudWatch → Log groups
2. Find `/ecs/ECS-with-IaC` (or your project name)
3. Click on log streams
4. Each ECS task will have its own stream: `ecs/lumia-image/<task-id>`

### AWS CLI
```bash
# List log streams
aws logs describe-log-streams \
  --log-group-name /ecs/ECS-with-IaC \
  --order-by LastEventTime \
  --descending

# Tail logs in real-time
aws logs tail /ecs/ECS-with-IaC --follow

# Get specific task logs
aws logs tail /ecs/ECS-with-IaC --follow --filter-pattern "error"
```

### Terraform Output
After deployment, get the log group name:
```bash
terraform output ecs_log_group
```

## What You'll See

### Application Logs
- All stdout/stderr from your container
- Database connection attempts
- Error messages
- Application startup logs

### Common Database Connection Issues

**Connection Refused:**
```
Error: Can't connect to MySQL server on 'xxx.rds.amazonaws.com' (111)
```
→ Check security group rules

**Access Denied:**
```
ERROR 1045 (28000): Access denied for user 'admin'@'xxx' (using password: YES)
```
→ Check database credentials

**Unknown Database:**
```
ERROR 1049 (42000): Unknown database 'myappdb'
```
→ Database name doesn't exist

**Timeout:**
```
ERROR 2003 (HY000): Can't connect to MySQL server (110)
```
→ Network/routing issue or RDS not ready

## Log Insights Queries

### Find Database Errors
```
fields @timestamp, @message
| filter @message like /database|mysql|connection/
| sort @timestamp desc
| limit 100
```

### Find All Errors
```
fields @timestamp, @message
| filter @message like /error|exception|failed/
| sort @timestamp desc
| limit 50
```

## Monitoring

The logs are automatically sent to CloudWatch. Your execution role already has permissions to write logs via `AmazonECSTaskExecutionRolePolicy`.

**Log Group:** `/ecs/ECS-with-IaC`
**Access:** Check outputs after `terraform apply`
