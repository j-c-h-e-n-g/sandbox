

variable "AWS_ACCESS_KEY_ID" { 
}

variable "AWS_SECRET_ACCESS_KEY" { 
}


variable "mesos_instance_count" { 
    default = "3"  
}


variable "instance_ips" {
  default = {
    "0" = "10.124.1.100"
    "1" = "10.124.1.101"
    "2" = "10.124.1.102"
    "3" = "10.124.1.103"
    "4" = "10.124.1.104"
    "5" = "10.124.1.105"
  }
}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "us-west-2"
}

variable "aws_instance_type" {
    default = "m1.small"
}

variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-b1cf19c6"
    us-east-1 = "ami-de7ab6b6"
    us-west-1 = "ami-3f75767a"
    us-west-2 = "ami-47465826"
  }
}

