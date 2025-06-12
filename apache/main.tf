resource "aws_instance" "example" {
  ami		= "ami-0953476d60561c955"  # Replace this with the latest Amazon Linux AMI in your region
  instance_type = "t2.micro"
  subnet_id = "" # Replace with your public facing subnet id
  associate_public_ip_address = true
user_data = <<-EOF
		#!/bin/bash
		yum install -y httpd
		systemctl start httpd
		systemctl enable httpd
		echo '<h1>Hello from Terraform!</h1>' > /var/www/html/index.html
		EOF

  tags = {
	Name = "SimpleWebServer"
  }
}
