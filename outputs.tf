output "instance_dns" {
  value = "${aws_instance.my-test-instance.public_dns}"
}
