terraform {
  backend "s3" {
    key = "test.txt"
    bucket = "austin-n-bucket"
  } 
}
