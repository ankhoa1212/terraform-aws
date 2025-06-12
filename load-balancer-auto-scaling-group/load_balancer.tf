resource "aws_lb" "austin_lb" {
  name               = "austin-lb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.austin_sg_for_elb.id]
  subnets            = [aws_subnet.austin_subnet_1.id, aws_subnet.austin_subnet_1a.id]
  depends_on         = [aws_internet_gateway.austin_gw]
}

resource "aws_lb_target_group" "austin_alb_tg" {
  name     = "austin-tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.austin_vpc.id
}

resource "aws_lb_listener" "austin_front_end" {
  load_balancer_arn = aws_lb.austin_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.austin_alb_tg.arn
  }
}