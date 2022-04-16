resource "aws_launch_configuration" "tf-launch_configuration" {
  name = "launch-config"
  image_id                    = "${data.aws_ami.amazon_linux.id}"#"ami-0bb273345f0961e90"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_agent.name}"
  instance_type               = "t3.small"
  lifecycle {
    create_before_destroy = true
  }
  security_groups             = [aws_security_group.dev-sg-elb.id]
  associate_public_ip_address = false
# key_name                    = var.key_name testing without
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.ecs_name}" >> /etc/ecs/ecs.config
EOF
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}