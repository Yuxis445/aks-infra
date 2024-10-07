variable "region" {
  type = string
  default = "West US 3"
}

variable "environment" {
  type = string
  default = "test"
}

variable "network_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "enable_argo" {
  type = string
  default = 1
}

variable "kube_config_path" {
  type    = string
  default = ""
  description = "Path to the kubeconfig file"
}

variable "db_name" {
  default = "db-dev"
}

variable "db_admin_username" {
  default = "dbadmin"
}

variable "db_admin_password" {
  default = "YourStrong!Passw0rd" # Ideally, use a secret management solution
}
