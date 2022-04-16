# Define the role.
resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_agent.json}"
}

# Allow EC2 service to assume this role.
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Give this role the permission to do ECS Agent things.
resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = "${aws_iam_role.ecs_agent.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = "${aws_iam_role.ecs_agent.name}"
}

