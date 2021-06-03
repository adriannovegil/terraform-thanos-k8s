#------------------------------------------------------------------------------
# Setup the Providers
#------------------------------------------------------------------------------
provider "kubernetes" {
  config_path            = "~/.kube/config"
  config_context_cluster = "minikube"
}

# Helm Provider - use helm provider w/ EKS credentials
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
