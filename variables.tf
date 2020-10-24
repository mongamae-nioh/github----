variable "vpc_cidr" {
  default = "n.n.n.n/nn"
}

variable "public_subnets_cidr" {
  type    = list(string)
  default = ["n.n.n.n/nn", "n.n.n.n/nn"]
}

variable "private_subnets_cidr" {
  type    = list(string)
  default = ["n.n.n.n/nn", "n.n.n.n/nn"]
}

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "gip" {
  type    = list(string)
  default = ["nnn.nnn.nnn.nnn/32", "nnn.nnn.nnn.nnn/32"]
}

variable "tags" {
  type = map(string)
  default = {
    Name  = "test"
  }
}

