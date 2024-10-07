variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "environment" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "pip_id" {
  type = string
}

variable "identity_id" {
  type = string
}

variable "min_count" {
  type    = number
  default = 1
}
variable "max_count" {
  type    = number
  default = 3
}