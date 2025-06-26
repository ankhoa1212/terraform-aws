resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_alb_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = var.web_ami
  instance_type = var.web_instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = [var.web_instance_sg_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
              )
}

resource "aws_autoscaling_group" "web" {
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_autoscaling_attachment" "web_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web.name
  lb_target_group_arn    = aws_lb_target_group.web.arn
}