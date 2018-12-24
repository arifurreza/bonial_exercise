output "instance_dns" {
  value = "${aws_instance.my-test-instance.public_dns}"
}

output "elb_address" {
  value = "${aws_elb.my-test-elb.dns_name}"
}
