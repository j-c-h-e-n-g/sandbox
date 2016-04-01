
provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_security_group" "master" {
  name = "mesos_master"
  description = "Allow incoming Mesos master and Marathon connections."

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 5050
    to_port = 5050
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "slave" {
  name = "mesos-slave"
  description = "Allow incoming Mesos slave"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 5051
    to_port = 5051
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

}

resource "aws_security_group" "egress-all" {
  name = "egress-all"
  description = "Allow all egress"

  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "master" {

  ami = "${var.ami}"

  vpc_security_group_ids = ["${aws_security_group.master.id}"]

  # security_groups = ["${aws_security_group.master.id}"]
  # security_groups = ["mesos-master"]

  instance_type = "${var.instance_type}"

}

resource "aws_instance" "slave1" {
  ami = "${var.ami}"
  vpc_security_group_ids = ["${aws_security_group.egress-all.id}", "${aws_security_group.slave.id}"]
  instance_type = "${var.instance_type}"
}

resource "aws_instance" "slave2" {

  ami = "${var.ami}"
  vpc_security_group_ids = ["${aws_security_group.egress-all.id}", "${aws_security_group.slave.id}"]
  instance_type = "${var.instance_type}"
}



  


