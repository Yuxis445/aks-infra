########################################################################
#                              Argo CD
########################################################################

resource "helm_release" "argocd" {
  count            = var.argocd_enabled ? 1 : 0
  name             = var.argocd_release_name
  repository       = var.argocd_repository_url
  chart            = var.argocd_chart_name
  namespace        = var.argocd_namespace
  create_namespace = true
  version          = var.argocd_chart_version

  values = [
    file("${path.module}/values/argo.yaml")
  ]
}

########################################################################
#                     Project -> Apps of Apps
########################################################################

resource "kubectl_manifest" "app_project" {
  count = var.argocd_enabled ? 1 : 0

  yaml_body  = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: ${var.argocd_project_name}
  namespace: ${var.argocd_namespace}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: ${var.argocd_project_description}
  sourceRepos:
    - '*'
  destinations:
    - namespace: "*"
      server: https://kubernetes.default.svc
  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
  namespaceResourceBlacklist:
    - group: ''
      kind: ResourceQuota
    - group: ''
      kind: LimitRange
    - group: ''
      kind: NetworkPolicy
  namespaceResourceWhitelist:
    - group: '*'
      kind: '*'
  orphanedResources:
    warn: ${var.orphaned_resources_warn}
  roles:
    - name: ${var.argocd_role_name}
      description: ${var.argocd_role_description}
      policies:
        - p, proj:${var.argocd_project_name}:${var.argocd_role_name}, applications, get, ${var.argocd_project_name}/*, allow
      groups:
        - ${var.argocd_oidc_group}
YAML
  depends_on = [helm_release.argocd]
}

########################################################################
#                    Apps of Apps
########################################################################

resource "kubectl_manifest" "apps_of_apps" {
  count = var.argocd_enabled ? 1 : 0

  yaml_body  = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.apps_of_apps_name}
  namespace: ${var.argocd_namespace}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  labels:
    name:  ${var.apps_of_apps_label}
spec:
  project: ${var.argocd_project_name}
  source:
    repoURL: ${var.apps_of_apps_repo_url}
    targetRevision: ${var.apps_of_apps_target_revision}
    path: ${var.apps_of_apps_path}
  destination:
    server: https://kubernetes.default.svc
    namespace: ${var.argocd_namespace}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - Validate=true
      - CreateNamespace=true 
      - PruneLast=true
    managedNamespaceMetadata:
      labels:
        managed: argocd
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
YAML
  depends_on = [helm_release.argocd]
}
