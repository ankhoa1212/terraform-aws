# ASG with Launch template
resource "aws_launch_template" "austin_ec2_launch_templ" {
  name_prefix   = "austin_ec2_launch_templ"
  image_id      = "ami-0953476d60561c955" # To note: AMI is specific for each region
  instance_type = "t2.micro"
  user_data     = filebase64("user_data.sh")

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.austin_subnet_1.id
    security_groups             = [aws_security_group.austin_sg_for_ec2.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Austin-instance" # Name for the EC2 instances
    }
  }
}

resource "aws_autoscaling_group" "austin_asg" {
  # no of instances
  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  # Connect to the target group
  target_group_arns = [aws_lb_target_group.austin_alb_tg.arn]

  # Creating EC2 instances in public subnets
  vpc_zone_identifier = [aws_subnet.austin_subnet_1.id, aws_subnet.austin_subnet_1a.id]

  launch_template {
    id      = aws_launch_template.austin_ec2_launch_templ.id
    version = "$Latest"
  }
}