# main.tf
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "sg" {
  source   = "./modules/sg"
  vpc_id   = module.vpc.vpc_id
  app_port = var.app_port
}

module "rds" {
  source               = "./modules/rds"
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_security_group_id = module.sg.db_security_group_id
  db_password          = var.db_password
  rds_kms_key_id       = module.kms.rds_key_arn
}

module "s3" {
  source = "./modules/s3"
  s3_kms_key_id = module.kms.s3_key_id
}

# SNS module first
module "sns" {
  source = "./modules/sns"
}

# Lambda module with SNS topic
module "lambda" {
  source           = "./modules/lambda"
  lambda_zip_path  = var.lambda_zip_path
  sendgrid_api_key = var.sendgrid_api_key
  sns_topic_arn    = module.sns.topic_arn
  email_credentials_arn = module.secrets.email_credentials_secret_arn
  kms_key_arn = [module.kms.secrets_key_arn, module.kms.rds_key_arn, module.kms.s3_key_arn, module.kms.ec2_key_arn]
}

module "route53" {
  source         = "./modules/route53"
  subdomain_name = var.subdomain_name
  lb_dns_name    = module.alb.lb_dns_name
  lb_zone_id     = module.alb.lb_zone_id
}

module "alb" {
  source               = "./modules/alb"
  lb_security_group_id = module.sg.lb_security_group_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  app_port            = var.app_port
  ssl_certificate_arn = var.ssl_certificate_arn
}

module "kms" {
  source = "./modules/kms"
}

module "secrets" {
  source = "./modules/secrets"
  kms_secrets_key_id = module.kms.secrets_key_id
  db_password        = var.db_password
  sendgrid_api_key   = var.sendgrid_api_key
}

module "asg" {
  source                = "./modules/asg"
  custom_ami            = var.custom_ami
  kms_key_arns          = [module.kms.secrets_key_arn, module.kms.rds_key_arn, module.kms.s3_key_arn, module.kms.ec2_key_arn]
  s3_kms_key_arn        = module.kms.s3_key_arn
  key_name              = var.key_name
  aws_profile           = var.aws_profile
  bucket_name           = module.s3.bucket_name
  bucket_arn            = module.s3.bucket_arn
  app_security_group_id = module.sg.app_security_group_id
  sns_topic_arn         = module.sns.topic_arn
  db_password_arn       = module.secrets.db_password_secret_arn
  email_credentials_arn = module.secrets.email_credentials_secret_arn
  user_data             = base64encode(<<-EOF
                              #!/bin/bash

                              export AWS_REGION=u${var.aws_region}
                              export AWS_DEFAULT_REGION=${var.aws_region}

                              DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${module.secrets.db_password_secret_name} --region ${var.aws_region} --query SecretString --output text)
                              SENDGRID_API_KEY=$(aws secretsmanager get-secret-value --secret-id ${module.secrets.email_credentials_secret_name} --region ${var.aws_region} --query SecretString --output text)

                              echo "DB_NAME=csye6225" >> /opt/apps/webapp/.env
                              echo "DB_USER=csye6225" >> /opt/apps/webapp/.env
                              echo "DB_PASSWORD=$DB_PASSWORD" >> /opt/apps/webapp/.env
                              echo "SENDGRID_API_KEY=$SENDGRID_API_KEY" >> /opt/apps/webapp/.env
                              echo "DB_HOST=${module.rds.db_endpoint}" >> /opt/apps/webapp/.env
                              echo "DB_PORT=5432" >> /opt/apps/webapp/.env
                              echo "AWS_REGION=${var.aws_region}" >> /opt/apps/webapp/.env
                              echo "S3_BUCKET_NAME=${module.s3.bucket_name}" >> /opt/apps/webapp/.env
                              echo "SNS_TOPIC_ARN=${module.sns.topic_arn}" >> /opt/apps/webapp/.env
                              echo "API_BASE_URL=https://${var.subdomain_name}.${var.domain_name}" >> /opt/apps/webapp/.env

                              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                                -a fetch-config \
                                -m ec2 \
                                -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
                                -s

                              sudo systemctl restart myapp
                              sudo systemctl restart amazon-cloudwatch-agent
                              EOF
  )
  lb_target_group_arn  = module.alb.lb_target_group_arn
  public_subnet_ids    = module.vpc.public_subnet_ids
}