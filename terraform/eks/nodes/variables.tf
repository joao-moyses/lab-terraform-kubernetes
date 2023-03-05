variable "eks_cluster" {}

variable "k8s_version" {}


variable "vpc_id" {
  description = "vpc id"
  type        = string
  default     = ""

}


variable "gateway_id" {
  description = "gateway_id"
  type        = string
  default     = ""

}


variable "name" {
  description = "name"
  type        = string
  default     = "lab-kubernetes"

}


variable "subnet_id_1a" {
  description = "subnet id1a"
  type        = string
  default     = ""

}

variable "subnet_id_1b" {
  description = "subnet id1b"
  type        = string
  default     = ""

}


variable "subnet_id_pub1a" {
  description = "subnet id1b"
  type        = string
  default     = ""

}

variable "subnet_id_pub1b" {
  description = "subnet id1b"
  type        = string
  default     = ""

}


variable "nodes_instances_sizes" {
  default = [
    "t3.large"
  ]
}

variable "auto_scale_options" {
  default = {
    min     = 2
    max     = 10
    desired = 2
  }
}

variable "auto_scale_cpu" {
  default = {
    scale_up_threshold  = 80
    scale_up_period     = 60
    scale_up_evaluation = 2
    scale_up_cooldown   = 300
    scale_up_add        = 2

    scale_down_threshold  = 40
    scale_down_period     = 120
    scale_down_evaluation = 2
    scale_down_cooldown   = 300
    scale_down_remove     = -1
  }
}