provider "kubernetes" {
  config_context_cluster   = "minikube"
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
     myapp = "MyWordpressSite"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        myapp = "MyWordpressSite"
      }
    }

    template {
      metadata {
        labels = {
          myapp = "MyWordpressSite"
        }
      }

      spec {
        container {
          image = "wordpress"
          name  = "wordpress-app"
        }
      }
    }
  }
}
resource "kubernetes_service" "wp_service"{
  metadata {
    name = "wp-service"
  }
  spec {
    selector = {
      myapp = "${kubernetes_deployment.wordpress.metadata.0.labels.myapp}"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}