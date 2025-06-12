module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db_sg"
  description = "Security group for db_sg"
  vpc_id      = data.aws_vpc.existing.id

  ingress_with_source_security_group_id = [
    {
      description              = "db access"
      rule                     = "postgresql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]
}
