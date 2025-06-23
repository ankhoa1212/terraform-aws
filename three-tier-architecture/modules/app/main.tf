resource "aws_lb" "app" {
  name               = "app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.app_alb_sg_id]
  subnets            = var.private_subnet_ids
}

resource "aws_launch_template" "app" {
  name_prefix   = "app-"
  image_id      = var.app_ami
  instance_type = var.app_instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = [var.app_instance_sg_id]
  }
}

resource "aws_autoscaling_group" "app" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}
