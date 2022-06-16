resource "kubernetes_config_map" "this" {
  count = var.add_configmap ? 1 : 0
  metadata {
    name      = "${var.name}-config"
    namespace = var.namespace
  }

  data = var.configmap_data
}

resource "kubernetes_secret" "this" {
  count = var.add_secret ? 1 : 0
  metadata {
    name      = "${var.name}-secret"
    namespace = var.namespace
  }

  data = var.secret_data
}

resource "kubernetes_service" "this" {
  metadata {
    name      = "${var.name}"
    namespace = var.namespace
  }
  spec {
    port {
      port        = var.service_port
      target_port = var.service_port
      protocol    = "TCP"
    }
    type = var.service_type
    selector = {
      app = var.name
    }
  }
}

resource "kubernetes_deployment" "this" {
  count = var.use_deploy_with_volume ? 0 : 1
  metadata {
    name      = "${var.name}"
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "200%"
        max_unavailable = "100%"
      }

    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          image = var.image_name
          name  = var.name

          port {
            container_port = var.service_port
          }

          env_from {
            config_map_ref {
              name = try(kubernetes_config_map.this[0].metadata.0.name, "default")
              optional = true
            }
          }

          env_from {
            secret_ref {
              name = try(kubernetes_secret.this[0].metadata.0.name, "default")
              optional = true
            }
          }

          resources {
            limits = {
              cpu    = "250m"
              memory = "250Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "this_with_volume" {
  count = var.use_deploy_with_volume ? 1 : 0
  metadata {
    name      = "${var.name}-deployment"
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = "200%"
        max_unavailable = "100%"
      }

    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          image = var.image_name
          name  = var.name

          port {
            container_port = var.service_port
          }

          env_from {
            config_map_ref {
              name = try(kubernetes_config_map.this[0].metadata.0.name, "default")
              optional = true
            }
          }

          env_from {
            secret_ref {
              name = try(kubernetes_secret.this[0].metadata.0.name, "default")
              optional = true
            }
          }

          resources {
            limits = {
              cpu    = "250m"
              memory = "250Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "50Mi"
            }
          }

          volume_mount {
            mount_path = var.volume_mount_path
            name       = var.name
          }
        }

        volume {
          name = var.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this[0].metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "this" {
  count = var.use_deploy_with_volume ? 1 : 0
  metadata {
    name      = "${var.name}-pv-claim"
    namespace = var.namespace
  }
  spec {
    storage_class_name = "local"
    access_modes       = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.volume_size
      }
    }
    volume_name = "${kubernetes_persistent_volume.this[0].metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "this" {
  count = var.use_deploy_with_volume ? 1 : 0
  metadata {
    name      = "${var.name}-pv"
  }
  spec {
    capacity = {
      storage = var.volume_size
    }
    storage_class_name = "local"
    access_modes       = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = var.host_path
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_ingress_v1" "this" {
  count = var.add_ingress ? 1 : 0
  wait_for_load_balancer = true
  metadata {
    name        = "${var.name}-ingress"
    namespace   = var.namespace
    annotations = {
      "kubernetes.io/ingress.class"      = "alb"
      "alb.ingress.kubernetes.io/scheme" = var.alb_scheme_type
    }
  }

  spec {
    default_backend {
      service {
        name = kubernetes_service.this.metadata.0.name
        port {
          number = var.service_port
        }
      }
    }
  }
}

