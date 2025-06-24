module "security" {
  source = "./modules/security"
  vpc_id = var.vpc_id
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  public_key_path   = var.public_key_path
  security_group_id = module.security.security_group_id
  op_service_account_token = var.op_service_account_token
}
