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
