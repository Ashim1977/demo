resource "kubernetes_namespace" "demoapp_ns" {
  metadata {
    name = "k8s-ns-by-tf"
  }
}
resource "kubernetes_pod" "demoapp_pod" {
  metadata {
    name = "demoapp"
    labels = {
      App = "demoapp"
    }
  }

  spec {
    container {
      image = "ashim1977/demoapp:latest"
      name  = "nodeapp"
      port {
        container_port = 8090
      }
    }
  }
}
# Let's create a Service object - in simple words, this object helps
# you with loadbalancing and network abstraction on top of pods
resource "kubernetes_service" "demoapp_service" {
  metadata {
    name = "demoapp-service"
  }
  spec {
    selector = {
        App = kubernetes_pod.demoapp_pod.metadata[0].labels.App
    }
    port {
      port        = 8090
      target_port = 8090
    }
  }
}
resource "kubernetes_ingress_v1" "demoapp_ingress" {
  metadata {
    name = "demoapp-ingress"
  }
  spec {
	ingress_class_name = "nginx"
    rule {
      host = "localhost"
      http {
        path {
          path    = "/"
          backend {
            service {
		name = kubernetes_service.demoapp_service.metadata.0.name
		port {
			number = 8090
		}
	    }
          }
        }
      }
    }
  }
}
