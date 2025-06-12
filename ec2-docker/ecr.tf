resource "aws_ecr_repository" "hello-world" {
  name                 = "hello-world"
  image_tag_mutability = "MUTABLE"

  tags = {
    project = "hello-world"
  }
}