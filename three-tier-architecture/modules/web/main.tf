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
              yum install -y nginx
              systemctl start nginx
              EOF
              )
}

resource "aws_autoscaling_group" "web" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}
