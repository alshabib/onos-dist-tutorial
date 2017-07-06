variable "instances_to_start" {
  description = "Instances that should be started"
  default = "1"
}

variable "profile" {
  description = "Profile to use for authentication to AWS"
  default = "onlab"
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "eu-central-1"
}

variable "instance_type" {
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "

    default     = "m4.xlarge"
}

variable "ubuntu_amis" {
    description = "ONOS Tutorial AMI Ids, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "

    default = {
      eu-central-1  = "ami-5e6aca31"
      eu-west-1     = "ami-c9d332b0"
      eu-west-2     = "ami-c6cfd9a2"
      us-west-1     = "ami-f8edc298"
    }
}

variable "tag_name" {
    default = "ONOS Distributed Tutorial"
}

variable "vpc_cidr" {
  default =  "10.0.0.0/16"
}

variable "subnet_cidr" {
  default =  "10.0.0.0/24"
}

variable "public_key" {
  description = "Public key used to login to ec2 instances."
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKJQn/tmIncECZne7sh+eN6iXJwNLaKbpg8/Ra1Arucm9hBhsoeUDBcqVVGyDxe7hcPRmQxIdkZwjFcwxAUmnut93kwoa08CmaY1jKGHnSn+2bUOLRBbt8u2PrI7zdOZxkSOd9uYxdfLD2VelfYqyayHeKaM3WRFln8LI0r5ehydrZPfbcN6xRVDjKd2ZQpYjc2/hSK+t1QX3K1cgrA+baPftvSbadth+qCeSM9U5c5CS7v0E84iHaM2fX+lBG3j9NwHWplVZLfHmoQbmRDKII+eQ5BmzibfGiKv0/+HBpDZ2piphL06/Ueb0Xyhq19D7Dd917cfc5HSn0RP8txrs1 ash@MacBook-Pro.lan"
}
