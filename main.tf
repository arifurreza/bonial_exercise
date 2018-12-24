provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

# Create a new load balancer
resource "aws_elb" "my-test-elb" {
  availability_zones = ["${aws_instance.my-test-instance.availability_zone}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.my-test-instance.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "test-elb"
  }
}

resource "aws_security_group" "default" {
  name        = "instance_sc"
  description = "Allow all 22 & 80 port inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-test-instance" {
  ami           = "${data.aws_ami.debian.id}"
  instance_type = "t2.micro"

  key_name                    = "${var.instance_access_key}"
  security_groups             = ["${aws_security_group.default.name}"]
  associate_public_ip_address = true

  tags {
    Name = "test-instance"
  }

  connection {
    user        = "${var.aws_instance_user}"
    private_key = "${file(var.aws_key_path)}"
  }

  provisioner "file" {
    source      = "aman/"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common",
      "sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/debian stretch stable'",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce",
      "sudo service docker start",
      "sudo docker pull nginx",
      "sudo docker run -d -p 80:80 -v /tmp:/usr/share/nginx/html --name nginx_test nginx",
    ]
  }
}
