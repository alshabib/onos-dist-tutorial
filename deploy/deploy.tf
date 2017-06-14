provider "aws" {
    region = "${var.aws_region}"
    profile = "${var.profile}"
}

resource "aws_key_pair" "tutorial" {
  key_name   = "tutorial-key"
  public_key = "${var.public_key}"
}

resource "aws_instance" "onos-dist-tutorial" {
  count = "${var.instances_to_start}"
    ami = "${lookup(var.ubuntu_amis, var.aws_region)}"
    vpc_security_group_ids = [ "${aws_security_group.onos_tutorial.id}"]
    key_name = "${aws_key_pair.tutorial.key_name}"
    instance_type = "${var.instance_type}"
    subnet_id = "${aws_subnet.main.id}"
    associate_public_ip_address = true

    tags {
        Name = "${var.tag_name}"
    }
}
