provider "aws" {
  region = "eu-west-3"
}

resource "aws_instance" "example1" {
  ami           = "ami-d179ceac"
  instance_type = "t2.micro"

  tags {
    Name = "myVm"
  }
}
