provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  name       = "leo_vpc"
}

module "network" {
  source       = "./modules/network"
  vpc_id       = module.vpc.vpc_id
  public_cidr  = "10.0.2.0/24"
  private_cidr = "10.0.1.0/24"
  az           = var.aws_sub_region
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source            = "./modules/ec2"
  ami               = var.instance_ami
  instance_type     = var.instance_type
  subnet_id         = module.network.public_subnet_id
  key_name          = "leonard-tf-key"
  public_key_path   = "leonard-tf-key.pub"
  security_group_id = module.security.security_group_id
}