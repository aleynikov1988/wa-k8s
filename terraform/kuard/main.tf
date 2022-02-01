locals {
  ingress_name = "kuard"
  ingress_ns   = "kuard-demo"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "nginx_ingress" {
  name             = local.ingress_name
  namespace        = local.ingress_ns
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"

  values = [
    "${file("values.yaml")}"
  ]
}
