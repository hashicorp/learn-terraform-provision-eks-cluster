resource "aws_ecs_cluster" "tf-ecs" {
  name = "${var.ecs_name}"
#  capacity_providers = [aws_ecs_capacity_provider.test-1.name]
  lifecycle {
    create_before_destroy = true
  }
}

#resource "aws_ecs_cluster_capacity_providers" "example" {
#  cluster_name = aws_ecs_cluster.tf-ecs.name
#
#  capacity_providers = [aws_ecs_capacity_provider.test-1.id]
#
#  default_capacity_provider_strategy {
#    base              = 1
#    weight            = 100
#    capacity_provider = aws_ecs_capacity_provider.test-1.name
#  }
#}
#
resource "aws_ecs_capacity_provider" "test-1" {
  name = "capacity-provider-test-1"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.tf-asg.arn

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}



#AWS ECS-Task Definition
data "aws_ecs_task_definition" "tf-data-tsd" {
  task_definition = aws_ecs_task_definition.tf-ecs-td.family
}

resource "aws_ecs_task_definition" "tf-ecs-td" {
  container_definitions    = file("image.json")
  family                   = "infocar-backend-qa-test"
  network_mode             = "bridge"
  execution_role_arn       = "arn:aws:iam::105882018630:role/ecsRoleGetParameters"
  requires_compatibilities = ["EC2"]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
}

resource "aws_ecs_service" "tf-ecs-svc" {
  name                    = var.ecs_name
  cluster                 = aws_ecs_cluster.tf-ecs.id
  desired_count           = 2
  task_definition         = aws_ecs_task_definition.tf-ecs-td.arn
  launch_type             = "EC2"
  enable_ecs_managed_tags = true
  force_new_deployment    = true

  load_balancer {
    target_group_arn = aws_lb_target_group.LB-TG-2.id
    container_name   = "backend-qa-test"
    container_port   = 80
  
  }
}
#105882018630.dkr.ecr.us-east-1.amazonaws.com/infocar-backend-qa:42faca6f096de6551a8c87a88e48699d6c141cce