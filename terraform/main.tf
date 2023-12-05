


terraform {
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "0.3.5"
    }
  }
}

provider "minikube" {
  kubernetes_version = "v1.27.4"
}

resource "minikube_cluster" "docker" {
  driver            = "docker"
  cluster_name      = "terraform"
  container_runtime = "docker"
  cni               = "bridge"
  addons = [
    "default-storageclass",
    "storage-provisioner"
  ]
  mount        = true
  mount_string = "/home/elizielx:/home/elizielx"
  network      = "minikube"
}

provider "kubernetes" {
  host                   = minikube_cluster.docker.host
  client_certificate     = minikube_cluster.docker.client_certificate
  client_key             = minikube_cluster.docker.client_key
  cluster_ca_certificate = minikube_cluster.docker.cluster_ca_certificate
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "nginx-example"
    labels = {
      App = "NginxExample"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "NginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "NginxExample"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "example"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name = "nginx-example"
    labels = {
      App = "NginxExample"
    }
  }

  spec {
    type = "NodePort"
    selector = {
      App = "NginxExample"
    }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
      name        = "http"
    }
  }
}
