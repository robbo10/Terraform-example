provider "aws" {
  region = "eu-west-3"
}

data "aws_availability_zones" "all" {}

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

resource "aws_launch_configuration" "example1" {
  image_id        = "ami-d179ceac"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.allow_instance_access.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Happy Friday" > index.html
              nohup busybox httpd -f -p "${var.vm_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example1" {
  launch_configuration = "${aws_launch_configuration.example1.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = 1
  max_size = 3

  tag {
    key                 = "Name"
    value               = "asg_vm_groups"
    propagate_at_launch = true
  }
}
