provider "aws" {
  region = "eu-west-3"
}

variable "vm_port" {
  default = 8080
}


resource "aws_security_group" "allow_instance_access" {
  name = "allow_webpage_access"

  ingress {
    from_port   = "${var.vm_port}"
    to_port     = "${var.vm_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_instance" "example1" {
  ami           = "ami-d179ceac"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow_instance_access.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Happy Friday!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags {
    Name = "myVm"
  }
}
