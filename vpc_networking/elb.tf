# AWS ELB config
resource "aws_lb" "alb-http" {
  name = "alb-http"
  internal = false
  load_balancer_type = "application"
  subnets = [aws_subnet.dev-subnet-public1-us-east-1a.id,aws_subnet.dev-subnet-public2-us-east-1b.id]
  security_groups = [aws_security_group.dev-sg-elb.id]

}
#security group for elb

resource "aws_security_group" "dev-sg-elb" {
  name = "dev-sg-elb"
  vpc_id = aws_vpc.module_vpc.id

  ingress {
    from_port   = var.ing_sg_port
    to_port     = var.ing_sg_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "LB-TG-2" {
  name     = "LB-TG-2"
  target_type = "instance"
  port     = var.lb_tg_port
  protocol = "HTTP"
  vpc_id = aws_vpc.module_vpc.id
  
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 60
    interval = 300
  }
}

resource "aws_alb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.alb-http.arn
  port              = var.lb_tg_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.LB-TG-2.id
  }
}