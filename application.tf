# Counting Service
resource "kubernetes_service_account" "counting" {
  metadata {
    name = "counting"
  }
}

resource "kubernetes_deployment" "counting" {
  metadata {
    name = "counting"
    labels = {
      app = "counting"
    }
    annotations = {
      "consul.hashicorp.com/connect-inject" = "true"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "counting"
      }
    }

    template {
      metadata {
        labels = {
          app = "counting"
        }
      }

      spec {
        service_account_name = "counting"
        container {
          image = "hashicorp/counting-service:0.0.2"
          name  = "counting"
          port {
            name           = "http"
            container_port = 9001
          }
        }
      }
    }
  }
}
