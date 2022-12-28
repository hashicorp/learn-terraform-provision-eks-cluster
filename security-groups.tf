resource "aws_security_group" "nodesec_group1" {
  name_prefix = "nodesec_group1"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "nodesec_group2" {
  name_prefix = "nodesec_group2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
