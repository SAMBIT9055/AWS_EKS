variable "region"{
    default = "ap-south-1"
}
variable "os-name"{
    default ="ami-0f5ee92e2d63afc18"
}
variable "instance-type"{
    default="t2.small"
}
variable "key"{
    default= "kubemaster"
}
 variable "vpc-cidr"{
    default="10.10.0.0/16"
 }

 variable "subnet1-cidr"{
    default="10.10.3.0/24"
 }
 
 variable "subnet2-cidr"{
    default="10.10.2.0/24"
 }
 variable "subnet-az-1"{
    default= "ap-south-1a"
 }
 variable "subnet-az-2"{
    default= "ap-south-1b"
 }