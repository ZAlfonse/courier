provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-f4cc1de2"
  instance_type = "t2.micro"
}
