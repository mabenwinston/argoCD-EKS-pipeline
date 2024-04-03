variable "location" {
  default = "us-east-1"
}

variable "ami-id" {
  default = "ami-0c101f26f147fa7fd"
}

variable "key" {
  default = "aws-key"
}

variable "instance-type" {
  default = "t2.small"
}

variable "vpc-cidr" {
  default = "10.10.0.0/16"
}

variable "subnet-01-cidr" {
  default = "10.10.1.0/24"

}

variable "subnet-02-cidr" {
  default = "10.10.2.0/24"

}
variable "subnet_az-01" {
  default = "us-east-1a"
}

variable "subnet_az-02" {
  default = "us-east-1b"
}