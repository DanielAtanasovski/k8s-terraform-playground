variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "dans-super-cluster"
}

variable "cluster_config_path" {
  type        = string
  description = "Cluster's kubeconfig location"
  default     = "~/.kube/config"
}


variable "github_username" {
  type = string
  sensitive = true
}

variable "github_token" {
  type = string
  sensitive = true
}