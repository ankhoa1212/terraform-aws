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

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum install mysql -y
              EOF
              )
}

resource "aws_autoscaling_group" "app" {
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_autoscaling_attachment" "app_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app.name
  lb_target_group_arn    = aws_lb_target_group.app.arn
}