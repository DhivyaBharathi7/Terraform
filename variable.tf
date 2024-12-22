#VPC variable
variable "vpc_cidr"{
    type = string
    default = "10.0.0.0/16"
}
variable "vpc_name"{
    type = string
    default = "my_vpc"
}
#subnetvariable
variable "s1"{
    default = "10.0.0.0/24"
}
variable "sub_name"{
    default = "p.sub1"
}
variable "s2"{
    default="10.0.1.0/24"
}
variable "sub_name1"{
    default = "p.sub2"
}