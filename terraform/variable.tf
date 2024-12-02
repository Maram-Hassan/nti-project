variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "pub_subnet" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24"]
  
}


variable "priv_subnet" {
    type = list(string)
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "az" {
    type = list(string)
    default = ["us-east-1a", "us-east-1b"]
  
}

variable "myami" {
    type = string
    default = "ami-005fc0f236362e99f"
}

variable "mykey" {
    type = string
    default = "terraformkey"
  
}