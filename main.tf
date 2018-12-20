provider "aws" {
  region = "${var.aws_region}"
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

  # provisioner "file" {
  #   source      = "files/"
  #   destination = "/tmp"
  # }

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
      "sudo echo just make one up and make the file part of your Github repo > /tmp/index.html",
    ]
  }
}
