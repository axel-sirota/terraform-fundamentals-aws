terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>3.0" # > bring 3.0.1 , brings 3.1.0, not 4.0.0
    }
  }
}
provider "docker" {
  host = "unix:///Users/axelsirota/.docker/run/docker.sock" // this is for mac, in windows should be host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "nginx" {
  name         = "nginx:1.18.0"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
