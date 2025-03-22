resource "kubernetes_namespace" "example" {
  metadata {
    name = var.name
  }
}

resource "kubernetes_limit_range" "example" {
  metadata {
    name = "resource-limit"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    limit {
      type = "Pod"
      max = {
        cpu    = "200m"
        memory = "1024Mi"
      }
    }
    limit {
      type = "PersistentVolumeClaim"
      min = {
        storage = "24M"
      }
    }
    limit {
      type = "Container"
      default = {
        cpu    = "50m"
        memory = "24Mi"
      }
    }
  }
}

resource "kubernetes_resource_quota" "example" {
  metadata {
    name = "terraform-example"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    hard = {
      pods = var.pod_quota
    }
    scopes = ["BestEffort"]
  }
}