# Counting Service
resource "kubernetes_service_account" "counting" {
  metadata {
    name = "counting"
  }
}

resource "kubernetes_pod" "counting" {
  metadata {
    name = "counting"

    annotations = {
      "consul.hashicorp.com/connect-inject" = "true"
    }
  }

  spec {
    container {
      name  = "counting"
      image = "hashicorp/counting-service:0.0.2"

      port {
        name           = "http"
        container_port = 9001
      }
    }

    service_account_name = "counting"
  }
}
