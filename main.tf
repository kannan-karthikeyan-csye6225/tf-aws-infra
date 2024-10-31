provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "sg" {
  source   = "./modules/sg"
  vpc_id   = module.vpc.vpc_id
  app_port = var.app_port
}

module "rds" {
  source              = "./modules/rds"
  private_subnet_ids  = module.vpc.private_subnet_ids
  db_security_group_id = module.sg.db_security_group_id
  db_password        = var.db_password
}

module "ec2" {
  source               = "./modules/ec2"
  custom_ami           = var.custom_ami
  public_subnet_id     = module.vpc.public_subnet_ids[0]
  app_security_group_id = module.sg.app_security_group_id
  db_password         = var.db_password
  db_endpoint         = module.rds.db_endpoint
  aws_region          = var.aws_region 
  bucket_name         = module.s3.bucket_name
}

module "s3" {
  source = "./modules/s3"
}

module "route53" {
  source             = "./modules/route53"
  subdomain_name     = var.subdomain_name
  instance_public_ip = module.ec2.instance_public_ip
}