variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {}
variable "public_subnet_1_cidr" {}
variable "public_subnet_2_cidr" {}
variable "private_subnet_1_cidr" {}
variable "private_subnet_2_cidr" {}
variable "eip_association_address" {}
variable "lb_tg_port" {}
variable "ing_sg_port" {}
variable "ecs_name" {}
variable "ecs_cpu" {}
variable "ecs_memory" {}
# variable "REPOSITORY_URL" {}
