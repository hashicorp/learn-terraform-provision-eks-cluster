module "vpc_networking" {
  source = "./vpc_networking"
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  eip_association_address = var.eip_association_address
  lb_tg_port = var.lb_tg_port
  ing_sg_port = var.ing_sg_port
  ecs_name = var.ecs_name
  ecs_cpu = var.ecs_cpu
  ecs_memory= var.ecs_memory
#  REPOSITORY_URL = var.REPOSITORY_URL
}