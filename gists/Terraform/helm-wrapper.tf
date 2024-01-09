resource "helm_release" "self" {
  create_namespace = true
  repository       = var.repo_url
  chart            = var.chart_name
  version          = var.chart_version
  namespace        = var.k8s_namespace
  name             = var.release_name
  atomic           = var.atomic
  wait             = var.wait
  values           = concat([for f in var.value_files : file(f)], var.runtime_value_yamls)

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
      type  = contains(var.force_string, set.key) ? "string" : "auto"
    }
  }

  dynamic "set_sensitive" {
    for_each = var.sensitive_settings
    content {
      name  = set_sensitive.key
      value = set_sensitive.value
      type  = contains(var.force_string, set_sensitive.key) ? "string" : "auto"
    }
  }
}

output "id" {
  value = helm_release.self.id
}

variable "chart_name" {}
variable "chart_version" {}
variable "release_name" {}
variable "repo_url" {}
variable "k8s_namespace" {}

variable "wait" {
  default = true
}

variable "atomic" {
  default = false
}

variable "settings" {
  default = {}
}

variable "sensitive_settings" {
  default = {}
}

variable "force_string" {
  default = []
}

variable "value_files" {
  default = []
}

variable "runtime_value_yamls" {
  default = []
}
