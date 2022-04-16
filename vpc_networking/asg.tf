resource "aws_autoscaling_group" "tf-asg" {
  name                      = "tf-asg"
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.tf-launch_configuration.name
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  target_group_arns    = [aws_lb_target_group.LB-TG-2.arn]
  vpc_zone_identifier = [aws_subnet.dev-subnet-private1-us-east-1a.id,aws_subnet.dev-subnet-private2-us-east-1b.id]
  protect_from_scale_in = true
  }

resource "aws_autoscaling_policy" "tf-asg-policy" {
  name                   = "${var.ecs_name}-scaling-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.tf-asg.name
}
