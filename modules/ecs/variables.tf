variable "project_name" {}
variable "container_cpu" {}
variable "container_memory" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "region" {}
variable "image_uri" {}
variable "target_group_arn" {}
variable "alb_listener_arn" {}


