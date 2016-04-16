provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY_ID}"
    secret_key = "${var.AWS_SECRET_ACCESS_KEY}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block = "10.124.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.124.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "default" {
  name        = "allow-ssh-and-http-from-vpc"
  description = "managed via Terraform"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.124.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/****
For this use case, it's Mesos on AWS and doens't span cloud providers --
i.e. AWS, Azure and SoftLayer together

.. therefore, the zookkeeper SG is just via the internal subnet

*/

resource "aws_security_group" "mesos-master" {
  name        = "allow-mesos-master"
  description = "managed via Terraform"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 5051
    to_port     = 5051
    protocol    = "tcp"
    cidr_blocks = ["10.124.0.0/16"]
  }
}

resource "aws_security_group" "mesos-slave" {
  name        = "allow-mesos-slave"
  description = "managed via Terraform"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 5050
    to_port     = 5050
    protocol    = "tcp"
    cidr_blocks = ["10.124.0.0/16"]
  }
}

resource "aws_security_group" "zookeeper" {
  name        = "allow-zookeeper"
  description = "managed via Terraform"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["10.124.0.0/16"]
  }
}


/*
zookeeper will live on this node, with quorum 1
*/

resource "aws_instance" "master1" {

  private_ip = "10.124.1.100"

  instance_type = "${var.aws_instance_type}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.default.id}", 
    "${aws_security_group.mesos-master.id}", 
    "${aws_security_group.zookeeper.id}"
  ]
  subnet_id = "${aws_subnet.default.id}"

  connection {
    user = "ubuntu"
    key_file = "${var.key_path}"
  }

  provisioner "remote-exec" {
    inline = [
      /* Install docker */
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo apt-get -y install python-pip && sudo pip install docker-compose"
    ]
  }

}


resource "aws_instance" "slave1" {

  private_ip = "10.124.1.101"

  instance_type = "${var.aws_instance_type}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.default.id}", 
    "${aws_security_group.mesos-master.id}", 
    "${aws_security_group.zookeeper.id}"
  ]
  subnet_id = "${aws_subnet.default.id}"

  connection {
    user = "ubuntu"
    key_file = "${var.key_path}"
  }

  provisioner "remote-exec" {
    inline = [
      /* Install docker */
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo apt-get -y install python-pip && sudo pip install docker-compose"
    ]
  }

}


resource "aws_instance" "slave2" {

  private_ip = "10.124.1.102"

  instance_type = "${var.aws_instance_type}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.default.id}", 
    "${aws_security_group.mesos-master.id}", 
    "${aws_security_group.zookeeper.id}"
  ]
  subnet_id = "${aws_subnet.default.id}"

  connection {
    user = "ubuntu"
    key_file = "${var.key_path}"
  }

  provisioner "remote-exec" {
    inline = [
      /* Install docker */
      "curl -sSL https://get.docker.com/ | sudo sh",
      "sudo apt-get -y install python-pip && sudo pip install docker-compose"
    ]
  }

}





