output "public_ips" {
    value = ["${aws_instance.onos-dist-tutorial.*.public_ip}"]
}
