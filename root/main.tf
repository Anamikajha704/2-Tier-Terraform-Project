module "vpc" {
    source = "../modules/vpc"
    vpc = var.vpc
    project_name = var.project_name
    region = var.region
    vpc_cidr = var.vpc_cidr
    public_sub_1a_cidr = var.public_sub_1a_cidr
    public_sub_2b_cidr = var.public_sub_2b_cidr
    private_sub_3a_cidr = var.private_sub_3a_cidr
    private_sub_4b_cidr = var.private_sub_4b_cidr
    private_sub_5a_cidr = var.private_sub_5a_cidr
    private_sub_6b_cidr = var.private_sub_6b_cidr
}

module "natgateway" {
  source = "../modules/natgateway"

  project_name = module.vpc.project_name
  igw_id       = module.vpc.igw_id
  vpc_id       = module.vpc.vpc_id

  public_subnet_1a_id  = module.vpc.public_sub_1a_id
  public_subnet_2b_id  = module.vpc.public_sub_2b_id
  private_subnet_3a_id = module.vpc.private_sub_3a_id
  private_subnet_4b_id = module.vpc.private_sub_4b_id
  private_subnet_5a_id = module.vpc.private_sub_5a_id
  private_subnet_6b_id = module.vpc.private_sub_6b_id
}

module "securitygroup" {
  source = "../modules/securitygroup"
  vpc_id = module.vpc.vpc_id
}

# creating Key for instances
module "key" {
  source = "../modules/key"
}

# Creating Application Load balancer
module "alb" {
  source = "../modules/alb"

  project_name         = module.vpc.project_name
  alb_sg_id            = module.securitygroup.alb_sg_id
  public_subnet_1a_id  = module.vpc.public_sub_1a_id
  public_subnet_2b_id  = module.vpc.public_sub_2b_id
  vpc_id               = module.vpc.vpc_id
}

#creating Auto Scaling group
module "asg" {
  source         = "../modules/asg"
  project_name   = module.vpc.project_name
  key_name       = module.key.key_name
  client_sg_id   = module.securitygroup.client_sg_id
  private_sub_3a_id = module.vpc.private_sub_3a_id
  private_sub_4b_id = module.vpc.private_sub_4b_id
  tg_arn         = module.alb.tg_arn

}

# creating RDS instance
module "rds" {
  source         = "../modules/rds"
  db_sg_id       = module.securitygroup.db_sg_id
  private_sub_5a_id = module.vpc.private_sub_5a_id
  private_sub_6b_id = module.vpc.private_sub_6b_id
  db_username    = var.db_username
  db_password    = var.db_password
}


# creating cloudfront distribution 
module "cloudfront" {
  source = "../modules/cloudfront"
  certificate_domain_name = var.certificate_domain_name
  alb_domain_name = module.alb.alb_dns_name
  additional_domain_name = var.additional_domain_name
  project_name = module.vpc.project_name
}


# Add record in route 53 hosted zone
module "route53" {
  source = "../modules/route53"
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id

}