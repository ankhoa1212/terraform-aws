resource "aws_launch_template" "bastion" {
  name_prefix            = "bastion"
  instance_type          = var.bastion_instance_type
  image_id               = var.bastion_ami
  vpc_security_group_ids = [var.bastion_sg]
  key_name               = var.key_name

  tags = {
    Name = "bastion"
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                = "bastion"
  vpc_zone_identifier = var.public_subnets
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }
}