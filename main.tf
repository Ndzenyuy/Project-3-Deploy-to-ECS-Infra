# main.tf (top of the file)
terraform {
  backend "s3" {
    bucket       = "ndzenyuy-test-bucket"
    key          = "ecs/deployment/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

module "network" {
  source       = "./modules/network"
  project_name = var.project_name
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  container_port    = 8080
}

module "ecs" {
  source             = "./modules/ecs"
  project_name       = var.project_name
  container_cpu      = var.container_cpu
  container_memory   = var.container_memory  
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.public_subnet_ids
  security_group_id  = module.network.ecs_security_group_id
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  region             = var.region
  image_uri          = var.image_uri
  target_group_arn   = module.alb.target_group_arn
  alb_listener_arn   = module.alb.alb_arn
}

module "rds" {
  source                = "./modules/rds"
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  allocated_storage     = var.allocated_storage
  instance_class        = var.db_instance_class
  vpc_id                = module.network.vpc_id
  private_subnets       = module.network.private_subnet_ids
  ecs_security_group_id = module.network.ecs_security_group_id
  project_name          = var.project_name
  environment           = var.environment
}

module "dashboard" {
  source                   = "./modules/dashboard"
  project_name             = var.project_name
  cluster_name             = module.ecs.cluster_name
  service_name             = module.ecs.service_name
  region                   = var.region
  alb_arn_suffix           = module.alb.alb_arn_suffix
  target_group_arn_suffix  = module.alb.target_group_arn_suffix
  db_instance_id           = module.rds.db_instance_id
}

# Lambda Event Module
module "lambda_event" {
  source          = "./modules/lambda-event"
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnet_ids
  lambda_sg_id    = module.network.ecs_security_group_id
  rds_endpoint    = module.rds.db_endpoint
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
  depends_on = [ module.rds ]
}

resource "null_resource" "invoke_lambda" {
  depends_on = [module.lambda_event]

  provisioner "local-exec" {
    command = "aws lambda invoke --function-name ${module.lambda_event.lambda_function_name} --payload '{}' response.json"
  }
}
