resource "kubernetes_service_account" "dashboard" {
  metadata {
    name = "dashboard"
  }
}

resource "kubernetes_pod" "dashboard" {
  metadata {
    name = "dashboard"

    labels = {
      app = "dashboard"
    }

    annotations = {
      "consul.hashicorp.com/connect-inject"            = "true"
      "consul.hashicorp.com/connect-service-upstreams" = "counting:9001"
    }
  }

  spec {
    container {
      name  = "dashboard"
      image = "hashicorp/dashboard-service:0.0.4"

      port {
        name           = "http"
        container_port = 9002
      }

      env {
        name  = "COUNTING_SERVICE_URL"
        value = "http://localhost:9001"
      }
    }

    service_account_name = "dashboard"
  }
}

resource "kubernetes_service" "dashboard_service_load_balancer" {
  metadata {
    name      = "dashboard-service-load-balancer"
    namespace = "default"

    labels = {
      app = "dashboard"
    }
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 8080
      target_port = "9002"
    }

    selector = {
      app = "dashboard"
    }

    type = "LoadBalancer"
  }
}
