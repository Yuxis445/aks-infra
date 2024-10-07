variable "enabled" {
  type = string
}

variable "kube_config" {}

variable "kubernetes_host" {}

variable "client_certificate" {}

variable "client_key" {}

variable "cluster_ca_certificate" {}

# Variables for AppProject settings
variable "argocd_project_name" {
  type    = string
  default = "main-project"
}

variable "argocd_project_description" {
  type    = string
  default = "Testing project"
}

variable "orphaned_resources_warn" {
  type    = bool
  default = false
}

variable "argocd_role_name" {
  type    = string
  default = "read-only"
}

variable "argocd_role_description" {
  type    = string
  default = "Read-only privileges to main-project"
}

variable "argocd_oidc_group" {
  type    = string
  default = "my-oidc-group"
}

# Variables for Argo CD settings
variable "argocd_enabled" {
  type    = bool
  default = true
}

variable "argocd_release_name" {
  type    = string
  default = "argocd-release"
}

variable "argocd_repository_url" {
  type    = string
  default = "https://argoproj.github.io/argo-helm"
}

variable "argocd_chart_name" {
  type    = string
  default = "argo-cd"
}

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "argocd_chart_version" {
  type    = string
  default = "5.35.0"
}

# Variables for Apps of Apps settings
variable "apps_of_apps_name" {
  type    = string
  default = "all-apps"
}

variable "apps_of_apps_label" {
  type    = string
  default = "allApps"
}

variable "apps_of_apps_repo_url" {
  type    = string
  default = "https://github.com/Yuxis445/aks-infra"
}

variable "apps_of_apps_target_revision" {
  type    = string
  default = "HEAD"
}

variable "apps_of_apps_path" {
  type    = string
  default = "modules/argo_cd/apps"
}

# Variables for Grafana Ingress
variable "grafana_namespace" {
  type    = string
  default = "grafana-monitoring"
}


variable "ingress_class_name" {
  type    = string
  default = "nginx"
}

variable "grafana_service_name" {
  type    = string
  default = "grafana-dev"
}

variable "grafana_service_port" {
  type    = number
  default = 80
}
