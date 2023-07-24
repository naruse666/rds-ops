resource "aws_security_group" "rds" {
  name   = "${local.name}-rds-sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "rds_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [local.cidr]
  security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
}
