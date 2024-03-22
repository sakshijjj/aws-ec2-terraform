variable "region" {
   default = "ap-northeast-1"
}
variable "ami" {
    default = "ami-039e8f15ccb15368a"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key-name" {
    default = "Tokyo"
}

variable "vpc_cidr" {
    default = "10.1.0.0/16"
}

variable "subnet_cidr" {
    default = "10.1.1.0/24"
}