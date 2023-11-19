terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.cluster_config_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.cluster_config_path)
  }
}

# Helm registry login to github
resource "null_resource" "github_helm_login" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "helm registry login ghcr.io -u ${var.github_username} -p ${var.github_token}"
  }
}

# Provision Vault
resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com/"
  chart            = "vault"
  create_namespace = true
  namespace        = "vault"

  values = [file("../vault-values/vault-values.yaml"), ]
}

# Provision Vault secrets operator
resource "helm_release" "vault-secrets-operator" {
  name             = "vault-secrets-operator"
  repository       = "https://helm.releases.hashicorp.com/"
  chart            = "vault-secrets-operator"
  create_namespace = true
  namespace        = "vault-secrets-operator"

  values = [file("../vault-values/vault-operator-values.yaml"), ]
}

# Provision Grafana Operator
resource "helm_release" "grafana-operator" {
  repository_username = var.github_username
  repository_password = var.github_token

  name              = "grafana-operator"
  repository        = "oci://ghcr.io/grafana-operator/helm-charts/"
  chart             = "grafana-operator"
  version           = "v5.4.2"

  create_namespace  = true
  namespace = "grafana-operator"
}