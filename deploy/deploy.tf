provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_instance" "onos" {
    ami = "${lookup(var.ubuntu_amis, var.aws_region)}"
    vpc_security_group_ids = [ "sg-33176f54"]
    key_name = "terraform"
    instance_type = "${var.instance_type}"
    subnet_id = "subnet-ac67f4f4"
    associate_public_ip_address = true

    tags {
        Name = "${var.tag_name}"
    }
}

output "public_ip" {
    value="${aws_instance.onos.public_ip}"
}
