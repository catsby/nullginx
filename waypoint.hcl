project = "nullginx"

app "nullginx" {
  labels = {
    "service" = "nullginx",
    "env"     = "dev"
  }

  build {
    use "docker-pull" {
      image="nginx"
      tag = "latest"
    }
    registry {
      use "docker" {
        # image = "catsby.jfrog.io/shrl-docker/nullginx"
        image = "localhost:5000/nullginx"
        tag   = "latest"

        # username = var.registry_username
        # password = var.registry_password
        local = false
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
    }
  }

  release {
    use "kubernetes" {
      // Sets up a load balancer to access released application
      load_balancer = true
      # port          = var.port
      port = 80
    }
  }
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/catsby/nullginx.git"
  }
}

# variable "regcred_secret" {
#   default     = "regcred"
#   type        = string
#   description = "The existing secret name inside Kubernetes for authenticating to the container registry"
# }

variable "port" {
  default     = 80
  type        = number
  description = "port the service is listening on"
}

# variable "registry_username" {
#   default = dynamic("vault", {
#     path = "secret/data/jfrogcreds"
#     key = "/data/username"
#   })
#   type        = string
#   sensitive   = true
#   description = "username for container registry"
# }

# variable "registry_password" {
#   default = dynamic("vault", {
#     path = "secret/data/jfrogcreds"
#     key = "/data/password"
#   })
#   type        = string
#   sensitive   = true
#   description = "password for registry" // DO NOT COMMIT YOUR PASSWORD TO GIT
# }

# variable "mongo_url" {
#   default = dynamic("terraform-cloud", {
#     organization = "hackweekfuntime"
#     workspace    = "waypoint-demo-tfc"
#     output       = "mongodb_url"
#   })
#   type    = string
#   sensitive   = true
#   description = "db url to connect"
# }
