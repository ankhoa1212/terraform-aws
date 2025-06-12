provider "aws" {
    //region not needed (s3 bucket is global)
}

resource  "aws_vpc" "test_vpc" {
    cidr_block = "10.0.0.0/16"
}
