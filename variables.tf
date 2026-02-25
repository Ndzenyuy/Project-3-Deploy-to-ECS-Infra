variable "project_name" {
  default = "ECS-with-IaC"
}

variable "container_cpu" {
  default = 256
}

variable "container_memory" {
  default = 512
}

variable "region" {
  default = "us-east-1"
}

variable "image_uri" {
  description = "Container image URI"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "myappdb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}



