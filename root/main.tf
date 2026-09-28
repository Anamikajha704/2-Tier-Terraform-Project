module "vpc"{
    source = "../modules/vpc"
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

module "natgateway"{
    source = "../modules/natgateway"
     igw_id        = module.vpc.igw_id
     vpc_id        = module.vpc.vpc_id
 public_sub_1a_id = module.vpc.public_sub_1a_id
 public_sub_2b_id = module.vpc.public_sub_2b_id
 private_sub_3a_id = module.vpc.private_sub_3a_id
 private_sub_4b_id = module.vpc.private_sub_4b_id   
  private_sub_5a_id = module.vpc.pri_sub_5a_id
  private_sub_6b_id = module.vpc.private_sub_6b_id
}

module "securitygroup" {
  source = "../modules/securitygroup"
  vpc_id = module.vpc.vpc_id
}


